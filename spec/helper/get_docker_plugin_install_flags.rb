# frozen_string_literal: true

def get_docker_plugin_install_flags(args)
  flags = []
  flags << "--alias #{args['plugin_alias']}" if args['plugin_alias'] && args['plugin_alias'].to_s != 'undef'
  flags << '--disable' if args['disable_on_install'] == true
  flags << '--disable-content-trust' if args['disable_content_trust'] == true
  flags << '--grant-all-permissions' if args['grant_all_permissions'] == true
  flags << "'#{args['plugin_name']}'" if args['plugin_name'] && args['plugin_name'].to_s != 'undef'

  if args['settings'].is_a? Array
    args['settings'].each do |setting|
      flags << setting.to_s
    end
  end

  flags.flatten.join(' ')
end
