require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'rspec/retry'

begin
  require 'pry'
rescue LoadError # rubocop:disable Lint/HandleExceptions for optional loading
end

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

def run_task(task_name:, params: nil, password: DEFAULT_PASSWORD)
  if pe_install?
    run_puppet_task(task_name: task_name, params: params)
  else
    run_bolt_task(task_name: task_name, params: params, password: password)
  end
end

def run_bolt_task(task_name:, params: nil, password: DEFAULT_PASSWORD)
  on(master, "/opt/puppetlabs/puppet/bin/bolt task run #{task_name} --modules /etc/puppetlabs/code/modules/service --nodes localhost --password #{password} #{params}", acceptable_exit_codes: [0, 1]).stdout # rubocop:disable Metrics/LineLength
end

def run_puppet_task(task_name:, params: nil)
  on(master, puppet('task', 'run', task_name, '--nodes', fact_on(master, 'fqdn'), params.to_s), acceptable_exit_codes: [0, 1]).stdout
end

#def expect_multiple_regexes(result:, regexes:)
#  regexes.each do |regex|
#    expect(result).to match(regex)
#  end
#end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # show retry status in spec process
  c.verbose_retry = true
  # show exception that triggers a retry if verbose_retry is set to true
  c.display_try_failure_messages = true

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|
      copy_module_to(host, :source => proj_root, :module_name => 'docker')
      # Due to RE-6764, running yum update renders the machine unable to install
      # other software. Thus this workaround.
      if fact_on(host, 'operatingsystem') == 'RedHat'
        on(host, 'mv /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/internal-mirror.repo')
      end
      on(host, 'yum update -y -q') if fact_on(host, 'osfamily') == 'RedHat'

      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-apt', '--version', '2.1.0'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'stahnma-epel'), { :acceptable_exit_codes => [0,1] }

      # net-tools required for netstat utility being used by some tests
      if fact_on(host, 'osfamily') == 'RedHat' && fact_on(host, 'operatingsystemmajrelease') == '7'
        on(host, 'yum install -y net-tools device-mapper')
      end

      docker_compose_content = <<-EOS
compose_test:
  image: ubuntu:14.04
  command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
      EOS
      docker_compose_content_v2 = <<-EOS
version: "2"
services:
  compose_test:
    image: ubuntu:14.04
    command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
      EOS
      create_remote_file(host, "/tmp/docker-compose.yml", docker_compose_content)
      create_remote_file(host, "/tmp/docker-compose-v2.yml", docker_compose_content_v2)
    end
  end
end
