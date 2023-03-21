# frozen_string_literal: true

require 'puppet_litmus'
require 'rspec/retry'
require 'tempfile'

include PuppetLitmus

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

def create_remote_file(name, full_name, file_content)
  Tempfile.open name do |tempfile|
    File.open(tempfile.path, 'w') { |file| file.puts file_content }
    bolt_upload_file(tempfile.path, full_name)
  end
end

def docker_run_idempotent_apply(pp)
  apply_manifest(pp)
  apply_manifest(pp).stdout.include?('Notice: No changes detected')
end

def fetch_puppet_version
  @fetch_puppet_version ||= run_shell('puppet --version').stdout.to_i
end

RSpec.configure do |c|
  # Add exclusive filter for Windows untill all the windows functionality is implemented
  c.filter_run_excluding win_broken: true

  # Readable test descriptions
  c.formatter = :documentation

  # show retry status in spec process
  c.verbose_retry = true
  # show exception that triggers a retry if verbose_retry is set to true
  c.display_try_failure_messages = true

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    # Due to RE-6764, running yum update renders the machine unable to install
    # other software. Thus this workaround.
    if os[:family] == 'redhat'
      run_shell('mv /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/internal-mirror.repo', expect_failures: true)
      run_shell('rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm', expect_failures: true)
      run_shell('yum update -y -q')
      # run_shell('yum upgrade -y')
    end
    if os[:family] == 'debian' || os[:family] == 'ubuntu'
      run_shell('apt-get update -y')
      # run_shell('apt-get upgrade -y')
      run_shell('apt-get install -y lsb-release')
      run_shell('apt-get install -y net-tools')
    end

    run_shell('puppet module install puppetlabs-stdlib --version 4.24.0', expect_failures: true)
    run_shell('puppet module install puppetlabs-apt --version 4.4.1', expect_failures: true)
    run_shell('puppet module install puppetlabs-translate --version 1.0.0', expect_failures: true)
    run_shell('puppet module install puppetlabs-powershell --version 2.1.5', expect_failures: true)
    run_shell('puppet module install puppetlabs-reboot --version 2.0.0', expect_failures: true)

    # net-tools required for netstat utility being used by some tests
    if os[:family] == 'redhat' && os[:release].to_i == 7
      run_shell('yum -y install lvm2 device-mapper device-mapper-persistent-data device-mapper-event device-mapper-libs device-mapper-event-libs')
      run_shell('yum install -y yum-utils net-tools')
      run_shell('yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo')
      run_shell('yum-config-manager --enable docker\*')
    end

    docker_compose_content_v3 = <<-EOS
version: "3.4"
x-images:
  &default-image
  alpine:3.8
services:
  compose_test:
    image: *default-image
    command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
      EOS
    docker_compose_override_v3 = <<-EOS
version: "3.4"
x-images:
  &default-image
  debian:stable-slim
services:
  compose_test:
    image: *default-image
    command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
        EOS
    docker_stack_override_v3 = <<-EOS
version: "3.4"
x-images:
  &default-image
  debian:stable-slim
services:
  compose_test:
    image: *default-image
    command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
        EOS
    docker_compose_content_v3_windows = <<-EOS
version: "3"
services:
  compose_test:
    image: winamd64/hello-seattle
    command: cmd.exe /C "ping 8.8.8.8 -t"
networks:
  default:
    external:
      name: nat
      EOS
    docker_compose_override_v3_windows = <<-EOS
version: "3"
services:
  compose_test:
    image: winamd64/hello-seattle:nanoserver
    command: cmd.exe /C "ping 8.8.8.8 -t"
networks:
  default:
    external:
      name: nat
      EOS
    docker_compose_override_v3_windows2016 = <<-EOS
version: "3"
services:
  compose_test:
    image: winamd64/hello-seattle:nanoserver-sac2016
    command: cmd.exe /C "ping 8.8.8.8 -t"
networks:
  default:
    external:
      name: nat
      EOS
    docker_stack_content_windows = <<-EOS
version: "3"
services:
  compose_test:
    image: winamd64/hello-seattle
    command: cmd.exe /C "ping 8.8.8.8 -t"
      EOS
    docker_stack_override_windows = <<-EOS
version: "3"
services:
  compose_test:
    image: winamd64/hello-seattle:nanoserver
      EOS
    docker_stack_override_windows2016 = <<-EOS
version: "3"
services:
  compose_test:
    image: winamd64/hello-seattle:nanoserver-sac2016
      EOS
    if os[:family] == 'windows'
      create_remote_file(host, '/tmp/docker-compose-v3.yml', docker_compose_content_v3_windows)
      create_remote_file(host, '/tmp/docker-stack.yml', docker_stack_content_windows)
      if %r{2019|2022}.match?(os[:release])
        create_remote_file(host, '/tmp/docker-compose-override-v3.yml', docker_compose_override_v3_windows)
        create_remote_file(host, '/tmp/docker-stack-override.yml', docker_stack_override_windows)
      else
        create_remote_file(host, '/tmp/docker-compose-override-v3.yml', docker_compose_override_v3_windows2016)
        create_remote_file(host, '/tmp/docker-stack-override.yml', docker_stack_override_windows2016)
      end
    else
      create_remote_file(host, '/tmp/docker-compose-v3.yml', docker_compose_content_v3)
      create_remote_file(host, '/tmp/docker-stack.yml', docker_compose_content_v3)
      create_remote_file(host, '/tmp/docker-compose-override-v3.yml', docker_compose_override_v3)
      create_remote_file(host, '/tmp/docker-stack-override.yml', docker_stack_override_v3)
    end

    next unless os[:family] == 'windows'
    result = run_shell("ipconfig | findstr /i 'ipv4'")
    raise 'Could not retrieve ip address for Windows box' if result.exit_code != 0
    ip = result.stdout.split("\n")[0].split(':')[1].strip
    retry_on_error_matching(60, 5, %r{connection failure running}) do
      @windows_ip = ip
    end
    apply_manifest("class { 'docker': docker_ee => true, extra_parameters => '\"insecure-registries\": [ \"#{@windows_ip}:5000\" ]' }", catch_failures: true)
    sleep 300
    docker_path = 'C:\\Program Files\\Docker'
    run_shell("set PATH \"%PATH%;C:\\Users\\Administrator\\AppData\\Local\\Temp;#{docker_path}\"")
    puts 'Waiting for box to come online'
    sleep 300
  end
end
