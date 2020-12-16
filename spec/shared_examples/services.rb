# frozen_string_literal: true

shared_examples 'services' do |title, params, facts, defaults|
  command         = params['command']
  create          = params['create']
  detach          = params['detach']
  ensure_value    = params['ensure']
  env             = params['env']
  extra_params    = params['extra_params']
  host_socket     = params['host_socket']
  image           = params['image']
  label           = params['label']
  mounts          = params['mounts']
  networks        = params['networks']
  publish         = params['publish']
  registry_mirror = params['registry_mirror']
  replicas        = params['replicas']
  scale           = params['scale']
  service_name    = params['service_name']
  tty             = params['tty']
  update          = params['update']
  user            = params['user']
  workdir         = params['workdir']

  docker_command = "#{defaults['docker_command']} service"

  if facts[:os]['family'] == 'windows'
    exec_environment = "PATH=#{facts['docker_program_files_path']}/Docker/;#{facts['docker_systemroot']}/System32/"
    exec_path        = ["#{facts['docker_program_files_path']}/Docker/"]
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

    exec_create   = "#{docker_command} create --name #{docker_service_create_flags}"
    unless_create = "docker service ps #{service_name == :undef ? '' : service_name}"

    it {
      is_expected.to contain_exec("#{title} docker service create").with(
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
      is_expected.to contain_exec("#{title} docker service update").with(
        'command'     => exec_update,
        'environment' => exec_environment,
        'path'        => exec_path,
        'provider'    => exec_provider,
        'timeout'     => exec_timeout,
      )
    }
  end

  if scale
    # docker_service_flags = get_docker_service_flags(
    #   'service_name' => service_name,
    #   'replicas'     => replicas,
    #   'extra_params' => Array(extra_params),
    # )

    exec_scale = "#{docker_command} scale #{service_name}=#{replicas}"

    it {
      is_expected.to contain_exec("#{title} docker service scale").with(
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
      is_expected.to contain_exec("#{title} docker service remove").with(
        'command'  => "docker service rm #{service_name}",
        'onlyif'   => "docker service ps #{service_name}",
        'path'     => exec_path,
        'provider' => exec_provider,
        'timeout'  => exec_timeout,
      )
    }
  end
end
