# frozen_string_literal: true

require 'shellwords'

def get_docker_run_flags(args)
  flags = []

  flags << "-u '#{args['username'].shellescape}'" if args['username']

  flags << "-h '#{args['hostname'].shellescape}'" if args['hostname']

  flags << "--restart '#{args['restart']}'" if args['restart']

  flags << "--net #{args['net']}" if args['net'].is_a? String

  flags << "-m #{args['memory_limit']}" if args['memory_limit']

  cpusets = [args['cpuset']].flatten.compact

  unless cpusets.empty?
    value = cpusets.join(',')
    flags << "--cpuset-cpus=#{value}"
  end

  flags << '-n false' if args['disable_network']

  flags << '--privileged' if args['privileged']

  flags << "--health-cmd='#{args['health_check_cmd']}'" if args['health_check_cmd'] && args['health_check_cmd'].to_s != 'undef'

  flags << "--health-interval=#{args['health_check_interval']}s" if args['health_check_interval'] && args['health_check_interval'].to_s != 'undef'

  flags << '-t' if args['tty']

  flags << '--read-only=true' if args['read_only']

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
