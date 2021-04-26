# frozen_string_literal: true

shared_examples 'secrets' do |title, params, _facts, defaults|
  ensure_value = params['ensure']
  label        = params['label']
  secret_name  = params['secret_name']
  secret_path  = params['secret_path']

  docker_command = "#{defaults['docker_command']} secret"

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
      is_expected.to contain_exec("#{title} docker secret create").with(
        'command' => exec_secret,
        'unless'  => unless_secret,
        'path'    => ['/bin', '/usr/bin'],
      )
    }
  end

  if ensure_value == 'absent'
    it {
      is_expected.to contain_exec("#{title} docker secret rm").with(
        'command' => "#{docker_command} rm #{secret_name}",
        'onlyif'  => "#{docker_command} inspect #{secret_name}",
        'path'    => ['/bin', '/usr/bin'],
      )
    }
  end
end
