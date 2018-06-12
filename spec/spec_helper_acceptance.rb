require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'rspec/retry'

begin
  require 'pry'
rescue LoadError # rubocop:disable Lint/HandleExceptions for optional loading
end

# This method allows a block to be passed in and if an exception is raised
# that matches the 'error_matcher' matcher, the block will wait a set number
# of seconds before retrying.
# Params:
# - max_retry_count - Max number of retries
# - retry_wait_interval_secs - Number of seconds to wait before retry
# - error_matcher - Matcher which the exception raised must match to allow retry
# Example Usage:
# retry_on_error_matching(3, 5, /OpenGPG Error/) do
#   apply_manifest(pp, :catch_failures => true)
# end
def retry_on_error_matching(max_retry_count = 3, retry_wait_interval_secs = 5, error_matcher = nil)
  try = 0
  begin
    try += 1
    yield
  rescue StandardError => e
    raise unless try < max_retry_count && (error_matcher.nil? || e.message =~ error_matcher)
    sleep retry_wait_interval_secs
    retry
  end
end

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'

RSpec.configure do |c|
  # Add exclusive filter for Windows untill all the windows functionality is implemented
  c.filter_run_excluding :win_broken => true

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
      if not_controller(host)
        copy_module_to(host, :source => proj_root, :module_name => 'docker')
        # Due to RE-6764, running yum update renders the machine unable to install
        # other software. Thus this workaround.
        if fact_on(host, 'operatingsystem') == 'RedHat'
          on(host, 'mv /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/internal-mirror.repo')
        end
        on(host, 'yum update -y -q') if fact_on(host, 'osfamily') == 'RedHat'

        on host, puppet('module', 'install', 'puppetlabs-stdlib', '--version', '4.24.0'), { :acceptable_exit_codes => [0,1] }
        on host, puppet('module', 'install', 'puppetlabs-apt', '--version', '4.4.1'), { :acceptable_exit_codes => [0,1] }
        on host, puppet('module', 'install', 'puppetlabs-translate', '--version', '1.0.0' ), { :acceptable_exit_codes => [0,1] }
        on host, puppet('module', 'install', 'puppetlabs-powershell', '--version', '2.1.5' ), { :acceptable_exit_codes => [0,1] }
        on host, puppet('module', 'install', 'puppetlabs-reboot', '--version', '2.0.0' ), { :acceptable_exit_codes => [0,1] }

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
        docker_compose_content_v3 = <<-EOS
version: "3"
services:
  compose_test:
    image: ubuntu:14.04
    command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
      EOS
        docker_compose_content_v3_windows = <<-EOS
version: "3"
services:
  compose_test:
    image: hello-world:nanoserver
    command: cmd.exe /C "ping /t 8.8.8.8"
networks:
  default:
    external:
      name: nat
      EOS
        create_remote_file(host, "/tmp/docker-compose.yml", docker_compose_content)
        create_remote_file(host, "/tmp/docker-compose-v2.yml", docker_compose_content_v2)
        if fact_on(host, 'osfamily') == 'windows'
          create_remote_file(host, "/tmp/docker-compose-v3.yml", docker_compose_content_v3_windows)
        else
          create_remote_file(host, "/tmp/docker-compose-v3.yml", docker_compose_content_v3)
        end

        if fact_on(host, 'osfamily') == 'windows'
          apply_manifest_on(host, "class { 'docker': docker_ee => true }")
          docker_path = "/cygdrive/c/Program Files/Docker"
          host.add_env_var('PATH', docker_path)
          puts "Waiting for box to come online"
          sleep 300
        end
      end
    end
  end
end
