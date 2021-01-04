# frozen_string_literal: true

shared_examples 'exec' do |_params, _facts, _defaults|
  command        = _params['command']
  container      = _params['container']
  detach         = _params['detach']
  docker_command = _defaults['docker_command']
  env            = _params['env']
  interactive    = _params['interactive']
  onlyif         = _params['onlyif']
  refreshonly    = _params['refreshonly']
  sanitise_name  = _params['sanitise_name']
  tty            = _params['tty']
  unless_value   = _params['unless']

  if _facts[:os]['family'] == 'windows'
    exec_environment = "PATH=#{_facts['docker_program_files_path']}/Docker/"
    exec_timeout     = 3000
    exec_path        = ["#{_facts['docker_program_files_path']}/Docker/"]
    exec_provider    = 'powershell'
  else
    exec_environment = 'HOME=/root'
    exec_path        = ['/bin', '/usr/bin']
    exec_timeout     = 0
    exec_provider    = nil
  end

  docker_exec_flags = get_docker_exec_flags(
    'detach' => detach,
    'interactive' => interactive,
    'tty'         => tty,
    'env'         => env,
  )

  sanitised_container = if sanitise_name
                          container.gsub('[^0-9A-Za-z.\-_]', '-')
                        else
                          container
                        end

  exec = "#{docker_command} exec #{docker_exec_flags} #{sanitised_container} #{command}"

  unless_command = case unless_value
                   when :undef
                     nil
                   when ''
                     nil
                   else
                     "#{docker_command} exec #{docker_exec_flags} #{sanitised_container} #{unless_value}"
                   end

  onlyif_command = case onlyif
                   when :undef
                     nil
                   when ''
                     nil
                   when 'running'
                     "#{docker_command} ps --no-trunc --format='table {{.Names}}' | grep '^#{sanitised_container}$'"
                   else
                     onlyif
                   end

  it {
    is_expected.to contain_exec(exec).with(
      'environment' => exec_environment,
      'onlyif'      => onlyif_command,
      'path'        => exec_path,
      'refreshonly' => refreshonly,
      'timeout'     => exec_timeout,
      'provider'    => exec_provider,
      'unless'      => unless_command,
    )
  }
end
