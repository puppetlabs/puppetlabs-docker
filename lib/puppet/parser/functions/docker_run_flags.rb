# frozen_string_literal: true

#
# docker_run_flags.rb
#
module Puppet::Parser::Functions
  newfunction(:'docker::escape', type: :rvalue) do |args|
    subject = args[0]

    escape_function = if self['facts'] && self['facts']['os']['family'] == 'windows'
                        'powershell_escape'
                      else
                        'shell_escape'
                      end

    call_function(escape_function, subject)
  end

  # Transforms a hash into a string of docker flags
  newfunction(:docker_run_flags, type: :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    if opts['username']
      flags << "-u #{call_function('docker::escape', [opts['username']])}"
    end

    if opts['hostname']
      flags << "-h #{call_function('docker::escape', [opts['hostname']])}"
    end

    if opts['restart']
      flags << "--restart '#{opts['restart']}'"
    end

    if opts['net']
      if opts['net'].is_a? String
        flags << "--net #{call_function('docker::escape', [opts['net']])}"
      elsif opts['net'].is_a? Array
        flags += opts['net'].map { |item| ["--net #{call_function('docker::escape', [item])}"] }
      end
    end

    if opts['memory_limit']
      flags << "-m #{opts['memory_limit']}"
    end

    cpusets = [opts['cpuset']].flatten.compact
    unless cpusets.empty?
      value = cpusets.join(',')
      flags << "--cpuset-cpus=#{value}"
    end

    if opts['disable_network']
      flags << '-n false'
    end

    if opts['privileged']
      flags << '--privileged'
    end

    if opts['health_check_cmd'] && opts['health_check_cmd'].to_s != 'undef'
      flags << "--health-cmd='#{opts['health_check_cmd']}'"
    end

    if opts['health_check_interval'] && opts['health_check_interval'].to_s != 'undef'
      flags << "--health-interval=#{opts['health_check_interval']}s"
    end

    if opts['tty']
      flags << '-t'
    end

    if opts['read_only']
      flags << '--read-only=true'
    end

    params_join_char = if opts['osfamily'] && opts['osfamily'].to_s != 'undef'
                         opts['osfamily'].casecmp('windows').zero? ? " `\n" : " \\\n"
                       else
                         " \\\n"
                       end

    multi_flags = ->(values, fmt) {
      filtered = [values].flatten.compact
      filtered.map { |val| (fmt + params_join_char) % call_function('docker::escape', [val]) }
    }

    [
      ['--dns %s',          'dns'],
      ['--dns-search %s',   'dns_search'],
      ['--expose=%s',       'expose'],
      ['--link %s',         'links'],
      ['--lxc-conf=%s',     'lxc_conf'],
      ['--volumes-from %s', 'volumes_from'],
      ['-e %s',             'env'],
      ['--env-file %s',     'env_file'],
      ['-p %s',             'ports'],
      ['-l %s',             'labels'],
      ['--add-host %s',     'hostentries'],
      ['-v %s',             'volumes'],
    ].each do |(format, key)|
      values    = opts[key]
      new_flags = multi_flags.call(values, format)
      flags.concat(new_flags)
    end

    opts['extra_params'].each do |param|
      flags << param
    end

    # Some software (inc systemd) will truncate very long lines using glibc's
    # max line length. Wrap options across multiple lines with '\' to avoid
    flags.flatten.join(params_join_char)
  end
end
