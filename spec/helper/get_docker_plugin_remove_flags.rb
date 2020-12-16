# frozen_string_literal: true

def get_docker_plugin_remove_flags(args)
  flags = []

  flags << '--force' if args['force_remove'] == true
  flags << "'#{args['plugin_name']}'" if args['plugin_name'] && args['plugin_name'].to_s != 'undef'

  flags.flatten.join(' ')
end
