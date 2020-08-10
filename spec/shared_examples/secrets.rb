shared_examples 'secrets' do |_title, _params, _facts, _defaults|
  ensure_value = _params['ensure']
  label        = _params['label']
  secret_name  = _params['secret_name']
  secret_path  = _params['secret_path']

  docker_command = "#{_defaults['docker_command']} secret"

  if ensure_value == 'present'
    docker_secrets_flags = get_docker_secrets_flags(
      'ensure' => ensure_value,
      'label'       => label,
      'secret_name' => secret_name,
      'secret_path' => secret_path,
    )

    exec_secret   = "#{docker_command} #{docker_secrets_flags}"
    unless_secret = "#{docker_command} inspect #{secret_name}"

    it {
      is_expected.to contain_exec("#{_title} docker secret create").with(
        'command' => exec_secret,
        'unless'  => unless_secret,
        'path'    => ['/bin', '/usr/bin'],
      )
    }
  end

  if ensure_value == 'absent'
    it {
      is_expected.to contain_exec("#{_title} docker secret rm").with(
        'command' => "#{docker_command} rm #{secret_name}",
        'onlyif'  => "#{docker_command} inspect #{secret_name}",
        'path'    => ['/bin', '/usr/bin'],
      )
    }
  end
end
