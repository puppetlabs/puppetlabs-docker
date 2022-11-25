# frozen_string_literal: true

shared_examples 'stack' do |_title, params, facts, defaults|
  ensure_value       = params['ensure']
  stack_name         = params['stack_name']
  bundle_file        = params['bundle_file']
  compose_files      = params['compose_files']
  prune              = params['prune']
  with_registry_auth = params['with_registry_auth']
  resolve_image      = params['resolve_image']

  # deprecation('docker::stack','The docker stack define type will be deprecated in a future release. Please migrate to the docker_stack type/provider.')

  docker_command = "#{defaults['docker_command']} stack"

  if facts[:os]['family'] == 'windows'
    exec_path   = ['C:/Program Files/Docker/']
    check_stack = '$info = docker stack ls | select-string -pattern web
                    if ($info -eq $null) { Exit 1 } else { Exit 0 }'
    provider    = 'powershell'
  else
    exec_path   = ['/bin', '/usr/bin']
    check_stack = "#{docker_command} ls | grep '#{stack_name}'"
    provider    = nil
  end

  if ensure_value == 'present'
    docker_stack_flags = get_docker_stack_flags(
      'stack_name' => stack_name,
      'bundle_file'        => bundle_file,
      'compose_files'      => compose_files,
      'prune'              => prune,
      'with_registry_auth' => with_registry_auth,
      'resolve_image'      => resolve_image,
    )

    exec_stack = "#{docker_command} deploy #{docker_stack_flags} #{stack_name}"

    it {
      is_expected.to contain_exec("docker stack create #{stack_name}").with(
        'command'  => exec_stack,
        'unless'   => check_stack,
        'path'     => exec_path,
        'provider' => provider,
      )
    }
  end

  if ensure_value == 'absent'
    it {
      is_expected.to contain_exec("docker stack destroy #{stack_name}").with(
        'command'  => "#{docker_command} rm #{stack_name}",
        'onlyif'   => check_stack,
        'path'     => exec_path,
        'provider' => provider,
      )
    }
  end
end
