# frozen_string_literal: true

shared_examples 'swarm' do |_title, params, facts, defaults|
  ensure_value                  = params['ensure']
  init                          = params['init']
  join                          = params['join']
  advertise_addr                = params['advertise_addr']
  autolock                      = params['autolock']
  cert_expiry                   = params['cert_expiry']
  default_addr_pool             = params['default_addr_pool']
  default_addr_pool_mask_length = params['default_addr_pool_mask_length']
  dispatcher_heartbeat          = params['dispatcher_heartbeat']
  external_ca                   = params['external_ca']
  force_new_cluster             = params['force_new_cluster']
  listen_addr                   = params['listen_addr']
  max_snapshots                 = params['max_snapshots']
  snapshot_interval             = params['snapshot_interval']
  token                         = params['token']
  manager_ip                    = params['manager_ip']

  if facts[:os]['family'] == 'windows'
    exec_environment = "PATH=#{facts['docker_program_files_path']}/Docker/"
    exec_path        = ["#{facts['docker_program_files_path']}/Docker/"]
    exec_timeout     = 3000
    exec_provider    = 'powershell'
    unless_init      = '$info = docker info | select-string -pattern "Swarm: active"
                         if ($info -eq $null) { Exit 1 } else { Exit 0 }'
    unless_join      = '$info = docker info | select-string -pattern "Swarm: active"
                         if ($info -eq $null) { Exit 1 } else { Exit 0 }'
    onlyif_leave     = '$info = docker info | select-string -pattern "Swarm: active"
                         if ($info -eq $null) { Exit 1 } else { Exit 0 }'
  else
    exec_environment = 'HOME=/root'
    exec_path        = ['/bin', '/usr/bin']
    exec_timeout     = 0
    exec_provider    = nil
    unless_init      = 'docker info | grep -w "Swarm: active"'
    unless_join      = 'docker info | grep -w "Swarm: active"'
    onlyif_leave     = 'docker info | grep -w "Swarm: active"'
  end

  docker_command = "#{defaults['docker_command']} swarm"

  if init
    docker_swarm_init_flags = get_docker_swarm_init_flags(
      'init' => init,
      'advertise_addr'                => advertise_addr,
      'autolock'                      => autolock,
      'cert_expiry'                   => cert_expiry,
      'dispatcher_heartbeat'          => dispatcher_heartbeat,
      'default_addr_pool'             => default_addr_pool,
      'default_addr_pool_mask_length' => default_addr_pool_mask_length,
      'external_ca'                   => external_ca,
      'force_new_cluster'             => force_new_cluster,
      'listen_addr'                   => listen_addr,
      'max_snapshots'                 => max_snapshots,
      'snapshot_interval'             => snapshot_interval,
    )

    exec_init = "#{docker_command} #{docker_swarm_init_flags}"

    it {
      is_expected.to contain_exec('Swarm init').with(
        'command'     => exec_init,
        'environment' => exec_environment,
        'path'        => exec_path,
        'provider'    => exec_provider,
        'timeout'     => exec_timeout,
        'unless'      => unless_init,
      )
    }
  end

  if join
    docker_swarm_join_flags = get_docker_swarm_join_flags(
      'join' => join,
      'advertise_addr' => advertise_addr,
      'listen_addr'    => listen_addr,
      'token'          => token,
    )

    exec_join = "#{docker_command} #{docker_swarm_join_flags} #{manager_ip}"

    it {
      is_expected.to contain_exec('Swarm join').with(
        'command'     => exec_join,
        'environment' => exec_environment,
        'path'        => exec_path,
        'provider'    => exec_provider,
        'timeout'     => exec_timeout,
        'unless'      => unless_join,
      )
    }
  end

  if ensure_value == 'absent'
    it {
      is_expected.to contain_exec('Leave swarm').with(
        'command'  => 'docker swarm leave --force',
        'onlyif'   => onlyif_leave,
        'path'     => exec_path,
        'provider' => exec_provider,
      )
    }
  end
end
