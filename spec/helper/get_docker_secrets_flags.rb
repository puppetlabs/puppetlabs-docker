# frozen_string_literal: true

require 'shellwords'

def get_docker_secrets_flags(args)
  flags = []

  flags << 'create' if args['ensure'].to_s == 'present'

  flags << "'#{args['secret_name']}'" if args['secret_name'] && args['secret_name'].to_s != 'undef'

  flags << "'#{args['secret_path']}'" if args['secret_path'] && args['secret_path'].to_s != 'undef'

  multi_flags = ->(values, format) {
    filtered = [values].flatten.compact
    filtered.map { |val| format + (" \\\n" % val) }
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
