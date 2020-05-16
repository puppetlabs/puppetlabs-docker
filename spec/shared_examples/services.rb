shared_examples 'services' do |_title, _params, _facts, _defaults|
  command         = _params['command']
  create          = _params['create']
  detach          = _params['detach']
  ensure_value    = _params['ensure']
  env             = _params['env']
  extra_params    = _params['extra_params']
  host_socket     = _params['host_socket']
  image           = _params['image']
  label           = _params['label']
  mounts          = _params['mounts']
  networks        = _params['networks']
  publish         = _params['publish']
  registry_mirror = _params['registry_mirror']
  replicas        = _params['replicas']
  scale           = _params['scale']
  service_name    = _params['service_name']
  tty             = _params['tty']
  update          = _params['update']
  user            = _params['user']
  workdir         = _params['workdir']

  docker_command = "#{_defaults['docker_command']} service"

  if _facts[:os]['family'] == 'windows'
    exec_environment = "PATH=#{_facts['docker_program_files_path']}/Docker/;#{_facts['docker_systemroot']}/System32/"
    exec_path        = ["#{_facts['docker_program_files_path']}/Docker/"]
    exec_provider    = 'powershell'
    exec_timeout     = 3000
  else
    exec_environment = 'HOME=/root'
    exec_path        = ['/bin', '/usr/bin']
    exec_provider    = nil
    exec_timeout     = 0
  end

  if create
    docker_service_create_flags = get_docker_service_flags(
      'detach'          => detach,
      'env'             => Array(env),
      'service_name'    => service_name,
      'label'           => Array(label),
      'publish'         => publish,
      'replicas'        => replicas,
      'tty'             => tty,
      'user'            => user,
      'workdir'         => workdir,
      'extra_params'    => Array(extra_params),
      'image'           => image,
      'host_socket'     => host_socket,
      'registry_mirror' => registry_mirror,
      'mounts'          => mounts,
      'networks'        => networks,
      'command'         => command,
    )

    _service_name = if service_name == :undef
                      ''
                    else
                      service_name
                    end

    exec_create   = "#{docker_command} create --name #{docker_service_create_flags}"
    unless_create = "docker service ps #{_service_name}"

    it {
      is_expected.to contain_exec("#{_title} docker service create").with(
        'command'     => exec_create,
        'environment' => exec_environment,
        'path'        => exec_path,
        'timeout'     => exec_timeout,
        'provider'    => exec_provider,
        'unless'      => unless_create,
      )
    }
  end

  if update
    docker_service_flags = get_docker_service_flags(
      'detach'          => detach,
      'env'             => Array(env),
      'service_name'    => service_name,
      'label'           => Array(label),
      'publish'         => publish,
      'replicas'        => replicas,
      'tty'             => tty,
      'user'            => user,
      'workdir'         => workdir,
      'extra_params'    => Array(extra_params),
      'image'           => image,
      'host_socket'     => host_socket,
      'registry_mirror' => registry_mirror,
    )

    exec_update = "#{docker_command} update #{docker_service_flags}"

    it {
      is_expected.to contain_exec("#{_title} docker service update").with(
        'command'     => exec_update,
        'environment' => exec_environment,
        'path'        => exec_path,
        'provider'    => exec_provider,
        'timeout'     => exec_timeout,
      )
    }
  end

  if scale
    docker_service_flags = get_docker_service_flags(
      'service_name' => service_name,
      'replicas'     => replicas,
      'extra_params' => Array(extra_params),
    )

    exec_scale = "#{docker_command} scale #{service_name}=#{replicas}"

    it {
      is_expected.to contain_exec("#{_title} docker service scale").with(
        'command'     => exec_scale,
        'environment' => exec_environment,
        'path'        => exec_path,
        'timeout'     => exec_timeout,
        'provider'    => exec_provider,
      )
    }
  end

  if ensure_value == 'absent'
    it {
      is_expected.to contain_exec("#{_title} docker service remove").with(
        'command'  => "docker service rm #{service_name}",
        'onlyif'   => "docker service ps #{service_name}",
        'path'     => exec_path,
        'provider' => exec_provider,
        'timeout'  => exec_timeout,
      )
    }
  end
end
