# frozen_string_literal: true

shared_examples 'plugin' do |_params, _facts, _defaults|
  ensure_value          = _params['ensure']
  plugin_name           = _params['plugin_name']
  enabled               = _params['enabled']
  timeout               = _params['timeout']
  plugin_alias          = _params['plugin_alias']
  disable_on_install    = _params['disable_on_install']
  disable_content_trust = _params['disable_content_trust']
  grant_all_permissions = _params['grant_all_permissions']
  force_remove          = _params['force_remove']
  settings              = _params['settings']

  docker_command = "#{_defaults['docker_command']} plugin"

  if ensure_value == 'present'
    docker_plugin_install_flags = get_docker_plugin_install_flags(
      'plugin_name' => plugin_name,
      'plugin_alias'          => plugin_alias,
      'disable_on_install'    => disable_on_install,
      'disable_content_trust' => disable_content_trust,
      'grant_all_permissions' => grant_all_permissions,
      'settings'              => settings,
    )

    exec_install   = "#{docker_command} install #{docker_plugin_install_flags}"
    unless_install = "#{docker_command} ls --format='{{.PluginReference}}' | grep -w #{plugin_name}"

    it {
      is_expected.to contain_exec("plugin install #{plugin_name}").with(
        'command'     => exec_install,
        'environment' => 'HOME=/root',
        'path'        => ['/bin', '/usr/bin'],
        'timeout'     => 0,
        'unless'      => unless_install,
      )
    }

  elsif ensure_value == 'absent'
    docker_plugin_remove_flags = get_docker_plugin_remove_flags(
      'plugin_name'  => plugin_name,
      'force_remove' => force_remove,
    )

    exec_rm   = "#{docker_command} rm #{docker_plugin_remove_flags}"
    onlyif_rm = "#{docker_command} ls --format='{{.PluginReference}}' | grep -w #{plugin_name}"

    it {
      is_expected.to contain_exec("plugin remove #{plugin_name}").with(
        'command'     => exec_rm,
        'environment' => 'HOME=/root',
        'path'        => ['/bin', '/usr/bin'],
        'timeout'     => 0,
        'onlyif'      => onlyif_rm,
      )
    }
  end

  if enabled
    docker_plugin_enable_flags = get_docker_plugin_enable_flags(
      'plugin_name'  => plugin_name,
      'plugin_alias' => plugin_alias,
      'timeout'      => timeout,
    )

    exec_enable   = "#{docker_command} enable #{docker_plugin_enable_flags}"
    onlyif_enable = "#{docker_command} ls -f enabled=false --format='{{.PluginReference}}' | grep -w #{plugin_name}"

    it {
      is_expected.to contain_exec("plugin enable #{plugin_name}").with(
        'command'     => exec_enable,
        'environment' => 'HOME=/root',
        'path'        => ['/bin', '/usr/bin'],
        'timeout'     => 0,
        'onlyif'      => onlyif_enable,
      )
    }
  else
    it {
      is_expected.to contain_exec("disable #{plugin_name}").with(
        'command'     => "#{docker_command} disable #{plugin_name}",
        'environment' => 'HOME=/root',
        'path'        => ['/bin', '/usr/bin'],
        'timeout'     => 0,
        'unless'      => "#{docker_command} ls -f enabled=false --format='{{.PluginReference}}' | grep -w #{plugin_name}",
      )
    }
  end
end
