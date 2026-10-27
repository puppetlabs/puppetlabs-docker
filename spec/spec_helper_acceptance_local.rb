# frozen_string_literal: true

require 'puppet_litmus'
require 'rspec/retry'
require 'tempfile'
require 'time'

include PuppetLitmus # rubocop:disable Style/MixinUsage

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

# Last boot time of the Windows host (UTC, ISO 8601); changes only when the host reboots.
def windows_boot_time
  run_shell("(Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToUniversalTime().ToString('o')").stdout.strip
end

def windows_reboot_pending?
  run_shell("Test-Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Component Based Servicing\\RebootPending'").stdout.strip.casecmp?('true')
end

# LastBootUpTime is derived from the uptime and can shift by a few seconds (e.g. after a clock
# sync), so only a jump of more than a minute counts as a reboot.
def windows_rebooted_since?(boot_time_before, boot_time_now)
  Time.iso8601(boot_time_now) - Time.iso8601(boot_time_before) > 60
rescue ArgumentError, TypeError
  false
end

# Installing Docker EE leaves a Component Based Servicing reboot pending. The reboot module
# only starts it (shutdown /r /t 1) once `puppet apply` has exited, so WinRM can still answer
# for a few seconds afterwards. Wait for the boot time to change, rather than for the first
# successful command, so that no example runs into the reboot.
# Params:
# - boot_time_before - windows_boot_time taken before the manifest that may reboot the host
# - timeout_secs - How long to wait for the host to come back
# - interval_secs - Seconds between probes
# - stable_probes - Consecutive successful probes needed after the reboot
# - max_extra_reboots - Restarts allowed if a reboot is still pending after the host comes back
def wait_for_windows_reboot(boot_time_before, timeout_secs: 1800, interval_secs: 10, stable_probes: 3, max_extra_reboots: 1)
  begin
    unless windows_reboot_pending?
      puts "No reboot pending (boot time #{boot_time_before}), not waiting"
      return
    end
  rescue StandardError => e
    puts "Reboot-pending probe failed, assuming the reboot has started: #{e.message.lines.first.to_s.strip}"
  end

  puts "Waiting up to #{timeout_secs / 60} minutes for the Windows host to reboot (boot time before: #{boot_time_before})"
  started = Time.now
  extra_reboots = 0
  loop do
    stable = 0
    until stable >= stable_probes
      raise "Windows host did not come back from the reboot within #{timeout_secs / 60} minutes (boot time before: #{boot_time_before})" if Time.now - started > timeout_secs

      sleep interval_secs
      begin
        boot_time_now = windows_boot_time
      rescue StandardError
        boot_time_now = nil
      end
      # Unreachable, or not rebooted yet: start counting again
      stable = windows_rebooted_since?(boot_time_before, boot_time_now) ? stable + 1 : 0
    end
    puts "Windows host rebooted after #{(Time.now - started).round} seconds (boot time #{boot_time_before} -> #{boot_time_now})"
    break unless windows_reboot_pending?
    raise "A reboot is still pending (Component Based Servicing\\RebootPending) after #{extra_reboots + 1} reboots" if extra_reboots >= max_extra_reboots

    # Otherwise the first manifest that includes the docker class would reboot the host mid-test
    extra_reboots += 1
    puts 'A reboot is still pending, restarting the Windows host again'
    boot_time_before = boot_time_now
    begin
      run_shell('shutdown /r /t 5')
    rescue StandardError
      # The connection can drop as the host shuts down
    end
  end
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
    if ['debian', 'ubuntu'].include?(os[:family])
      run_shell('apt-get update -y')
      # run_shell('apt-get upgrade -y')
      run_shell('apt-get install -y lsb-release')
      run_shell('apt-get install -y net-tools')
      run_shell('apt-get purge -y container-tools') if ENV['CI']
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

    docker_compose_content_v3 = <<~EOS
      version: "3.4"
      x-images:
        &default-image
        alpine:3.8
      services:
        compose_test:
          image: *default-image
          command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
    EOS
    docker_compose_override_v3 = <<~EOS
      version: "3.4"
      x-images:
        &default-image
        debian:stable-slim
      services:
        compose_test:
          image: *default-image
          command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
    EOS
    docker_stack_override_v3 = <<~EOS
      version: "3.4"
      x-images:
        &default-image
        debian:stable-slim
      services:
        compose_test:
          image: *default-image
          command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
    EOS
    docker_stack_content_windows = <<~EOS
      version: "3"
      services:
        compose_test:
          image: winamd64/hello-seattle
          command: cmd.exe /C "ping 8.8.8.8 -t"
    EOS
    docker_stack_override_windows = <<~EOS
      version: "3"
      services:
        compose_test:
          image: winamd64/hello-seattle:nanoserver
    EOS
    docker_stack_override_windows2016 = <<~EOS
      version: "3"
      services:
        compose_test:
          image: winamd64/hello-seattle:nanoserver-sac2016
    EOS
    if os[:family] == 'windows'
      create_remote_file(host, '/tmp/docker-stack.yml', docker_stack_content_windows)
      if %r{2019|2022}.match?(os[:release])
        create_remote_file(host, '/tmp/docker-stack-override.yml', docker_stack_override_windows)
      else
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
    boot_time_before = retry_on_error_matching(12, 5) { windows_boot_time }
    apply_manifest("class { 'docker': docker_ee => true, extra_parameters => '\"insecure-registries\": [ \"#{@windows_ip}:5000\" ]' }", catch_failures: true)
    wait_for_windows_reboot(boot_time_before)
    docker_path = 'C:\\Program Files\\Docker'
    retry_on_error_matching(120, 5, %r{.*}) do
      run_shell("set PATH \"%PATH%;C:\\Users\\Administrator\\AppData\\Local\\Temp;#{docker_path}\"")
    end
  end
end
