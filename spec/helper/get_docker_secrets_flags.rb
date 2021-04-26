# frozen_string_literal: true

require 'shellwords'

def get_docker_secrets_flags(args)
  flags = []

  if args['ensure'].to_s == 'present'
    flags << 'create'
  end

  if args['secret_name'] && args['secret_name'].to_s != 'undef'
    flags << "'#{args['secret_name']}'"
  end

  if args['secret_path'] && args['secret_path'].to_s != 'undef'
    flags << "'#{args['secret_path']}'"
  end

  multi_flags = ->(values, format) {
    filtered = [values].flatten.compact
    filtered.map { |val| format + " \\\n" % val }
  }
  [
    ['-l %s', 'label'],
  ].each do |(format, key)|
    values    = args[key]
    new_flags = multi_flags.call(values, format)
    flags.concat(new_flags)
  end

  flags.flatten.join(' ')
end
