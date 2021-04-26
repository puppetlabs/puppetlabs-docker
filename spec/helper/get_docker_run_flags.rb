# frozen_string_literal: true

require 'shellwords'

def get_docker_run_flags(args)
  flags = []

  if args['username']
    flags << "-u '#{args['username'].shellescape}'"
  end

  if args['hostname']
    flags << "-h '#{args['hostname'].shellescape}'"
  end

  if args['restart']
    flags << "--restart '#{args['restart']}'"
  end

  if args['net'].is_a? String
    flags << "--net #{args['net']}"
  end

  if args['memory_limit']
    flags << "-m #{args['memory_limit']}"
  end

  cpusets = [args['cpuset']].flatten.compact

  unless cpusets.empty?
    value = cpusets.join(',')
    flags << "--cpuset-cpus=#{value}"
  end

  if args['disable_network']
    flags << '-n false'
  end

  if args['privileged']
    flags << '--privileged'
  end

  if args['health_check_cmd'] && args['health_check_cmd'].to_s != 'undef'
    flags << "--health-cmd='#{args['health_check_cmd']}'"
  end

  if args['health_check_interval'] && args['health_check_interval'].to_s != 'undef'
    flags << "--health-interval=#{args['health_check_interval']}s"
  end

  if args['tty']
    flags << '-t'
  end

  if args['read_only']
    flags << '--read-only=true'
  end

  params_join_char = if args['osfamily'] && args['osfamily'].to_s != 'undef'
                       args['osfamily'].casecmp('windows').zero? ? " `\n" : " \\\n"
                     else
                       " \\\n"
                     end

  multi_flags = ->(values, fmt) {
    filtered = [values].flatten.compact
    filtered.map { |val| (fmt + params_join_char) % val }
  }

  [
    ['--dns %s',          'dns'],
    ['--dns-search %s',   'dns_search'],
    ['--expose=%s',       'expose'],
    ['--link %s',         'links'],
    ['--lxc-conf="%s"',   'lxc_conf'],
    ['--volumes-from %s', 'volumes_from'],
    ['-e "%s"',           'env'],
    ['--env-file %s',     'env_file'],
    ['-p %s',             'ports'],
    ['-l %s',             'labels'],
    ['--add-host %s',     'hostentries'],
    ['-v %s',             'volumes'],
  ].each do |format, key|
    values    = args[key]
    new_flags = multi_flags.call(values, format)
    flags << new_flags
  end

  args['extra_params'].each do |param|
    flags << param if args['param'].to_s != 'undef'
  end

  # Some software (inc systemd) will truncate very long lines using glibc's
  # max line length. Wrap options across multiple lines with '\' to avoid
  flags.flatten.reject { |val| val.to_s == 'undef' }.join(params_join_char)
end
