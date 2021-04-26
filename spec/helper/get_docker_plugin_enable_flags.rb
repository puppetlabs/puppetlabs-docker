# frozen_string_literal: true

def get_docker_plugin_enable_flags(args)
  flags = []

  flags << '--force' if args['force_remove'] == true
  if args['plugin_alias'] && args['plugin_alias'].to_s != 'undef'
    flags << "'#{args['plugin_alias']}'"
  elsif args['plugin_name'] && args['plugin_name'].to_s != 'undef'
    flags << "'#{args['plugin_name']}'"
  end

  flags.flatten.join(' ')
end
