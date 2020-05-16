shared_examples 'run' do |_title, _params, _facts, _defaults|
  after                             = _params['after']
  after_create                      = _params['after_create']
  after_service                     = _params['after_service']
  after_start                       = _params['after_start']
  after_stop                        = _params['after_stop']
  before_start                      = _params['before_start']
  before_stop                       = _params['before_stop']
  command                           = _params['command']
  cpuset                            = _params['cpuset']
  custom_unless                     = _params['custom_unless']
  depend_services                   = _params['depend_services']
  depends                           = _params['depends']
  detach                            = _params['detach']
  disable_network                   = _params['disable_network']
  dns                               = _params['dns']
  dns_search                        = _params['dns_search']
  docker_service                    = _params['docker_service']
  ensure_value                      = _params['ensure']
  env                               = _params['env']
  env_file                          = _params['env_file']
  expose                            = _params['expose']
  extra_parameters                  = _params['extra_parameters']
  extra_systemd_parameters          = _params['extra_systemd_parameters']
  health_check_cmd                  = _params['health_check_cmd']
  health_check_interval             = _params['health_check_interval']
  hostentries                       = _params['hostentries']
  hostname                          = _params['hostname']
  image                             = _params['image']
  labels                            = _params['labels']
  links                             = _params['links']
  lxc_conf                          = _params['lxc_conf']
  manage_service                    = _params['manage_service']
  memory_limit                      = _params['memory_limit']
  net                               = _params['net']
  ports                             = _params['ports']
  privileged                        = _params['privileged']
  pull_on_start                     = _params['pull_on_start']
  read_only                         = _params['read_only']
  remain_after_exit                 = _params['remain_after_exit']
  remove_container_on_start         = _params['remove_container_on_start']
  remove_container_on_stop          = _params['remove_container_on_stop']
  remove_volume_on_start            = _params['remove_volume_on_start']
  remove_volume_on_stop             = _params['remove_volume_on_stop']
  restart                           = _params['restart']
  restart_on_unhealthy              = _params['restart_on_unhealthy']
  restart_service                   = _params['restart_service']
  restart_service_on_docker_refresh = _params['restart_service_on_docker_refresh']
  running                           = _params['running']
  service_prefix                    = _params['service_prefix']
  service_provider                  = _params['service_provider']
  socket_connect                    = _params['socket_connect']
  stop_wait_time                    = _params['stop_wait_time']
  syslog_identifier                 = _params['syslog_identifier']
  systemd_restart                   = _params['systemd_restart']
  tty                               = _params['tty']
  use_name                          = _params['use_name']
  username                          = _params['username']
  volumes                           = _params['volumes']
  volumes_from                      = _params['volumes_from']
  docker_group                      = _defaults['docker_group']

  if socket_connect != []
    sockopts       = [socket_connect].join(',')
    docker_command = "#{_defaults['docker_command']} -H #{sockopts}"
  else
    docker_command = _defaults['docker_command']
  end

  if use_name
    it {
      is_expected.to contain_notify("docker use_name warning: #{_title}").with(
        'message'  => 'The use_name parameter is no-longer required and will be removed in a future release',
        'withpath' => true,
      )
    }
  end

  service_provider_real = case service_provider.to_s
                          when 'undef'
                            _defaults['service_provider']
                          else
                            service_provider
                          end

  valid_detach = if detach == :undef
                   case service_provider_real
                   when 'systemd'
                     false
                   else
                     _defaults['detach_service_in_init']
                   end
                 else
                   detach
                 end

  docker_run_flags = get_docker_run_flags(
    'cpuset' => [cpuset],
    'disable_network'       => disable_network,
    'dns_search'            => [dns_search],
    'dns'                   => [dns],
    'env_file'              => [env_file],
    'env'                   => [env],
    'expose'                => [expose],
    'extra_params'          => [extra_parameters],
    'health_check_cmd'      => health_check_cmd,
    'health_check_interval' => health_check_interval,
    'hostentries'           => [hostentries],
    'hostname'              => hostname,
    'labels'                => [labels],
    'links'                 => [links],
    'lxc_conf'              => [lxc_conf],
    'memory_limit'          => memory_limit,
    'net'                   => net,
    'osfamily'              => _facts[:os]['family'],
    'ports'                 => [ports],
    'privileged'            => privileged,
    'read_only'             => read_only,
    'restart_on_unhealthy'  => restart_on_unhealthy,
    'socket_connect'        => [socket_connect],
    'tty'                   => tty,
    'username'              => username,
    'volumes_from'          => [volumes_from],
    'volumes'               => [volumes],
  )

  sanitised_title = _title.gsub('[^0-9A-Za-z.\-_]', '-')

  if _facts[:os]['family'] == 'windows'
    exec_environment        = "PATH=#{_facts['docker_program_files_path']}/Docker/;#{_facts['docker_systemroot']}/System32/"
    exec_timeout            = 3000
    exec_path               = ["#{_facts['docker_program_files_path']}/Docker/"]
    exec_provider           = 'powershell'
    cidfile                 = "#{_facts['docker_user_temp_path']}/#{service_prefix}#{sanitised_title}.cid"
    restart_check           = "#{docker_command} inspect #{sanitised_title} -f '{{ if eq \\\"unhealthy\\\" .State.Health.Status }} {{ .Name }}{{ end }}' | findstr #{sanitised_title}"
    container_running_check = "\$state = #{docker_command} inspect #{sanitised_title} -f \"{{ .State.Running }}\"; if (\$state -ieq \"true\") { Exit 0 } else { Exit 1 }"
  else
    exec_environment        = 'HOME=/root'
    exec_path               = ['/bin', '/usr/bin']
    exec_timeout            = 0
    exec_provider           = nil
    cidfile                 = "/var/run/#{service_prefix}#{sanitised_title}.cid"
    restart_check           = "#{docker_command} inspect #{sanitised_title} -f '{{ if eq \"unhealthy\" .State.Health.Status }} {{ .Name }}{{ end }}' | grep #{sanitised_title}"
    container_running_check = "#{docker_command} inspect #{sanitised_title} -f \"{{ .State.Running }}\" | grep true"
  end

  if restart_on_unhealthy
    it {
      is_expected.to contain_exec("Restart unhealthy container #{_title} with docker").with(
        'command'     => "#{docker_command} restart #{sanitised_title}",
        'onlyif'      => restart_check,
        'environment' => exec_environment,
        'path'        => exec_path,
        'provider'    => exec_provider,
        'timeout'     => exec_timeout,
      )
    }
  end

  if restart.to_s != 'undef'
    if ensure_value == 'absent'
      it {
        is_expected.to contain_exec("stop #{_title} with docker").with(
          'command'     => "#{docker_command} stop --time=#{stop_wait_time} #{sanitised_title}",
          'onlyif'      => "#{docker_command} inspect #{sanitised_title}",
          'environment' => exec_environment,
          'path'        => exec_path,
          'provider'    => exec_provider,
          'timeout'     => exec_timeout,
        )

        is_expected.to contain_exec("remove #{_title} with docker").with(
          'command'     => "#{docker_command} rm -v #{sanitised_title}",
          'onlyif'      => "#{docker_command} inspect #{sanitised_title}",
          'environment' => exec_environment,
          'path'        => exec_path,
          'provider'    => exec_provider,
          'timeout'     => exec_timeout,
        )

        is_expected.to contain_file(cidfile).with(
          'ensure' => 'absent',
        )
      }
    else
      run_with_docker_command = [
        "#{docker_command} run -d #{docker_run_flags}",
        "--name #{sanitised_title} --cidfile=#{cidfile}",
        "--restart=\"#{restart}\" #{image} #{command}",
      ]

      inspect = [
        "#{docker_command} inspect #{sanitised_title}",
      ]

      exec_unless = if custom_unless
                      custom_unless << inspect
                    else
                      inspect
                    end

      it {
        is_expected.to contain_exec("run #{_title} with docker").with(
          'command'     => run_with_docker_command.join(' '),
          ## todo:
          ## fix the following strange behavior:
          ## expected that the catalogue would contain Exec[run command with docker] with unless set to [["docker inspect command"]]
          ## but it is set to [["docker inspect command"], "docker inspect command"]
          # 'unless'      => exec_unless,
          'environment' => exec_environment,
          'path'        => exec_path,
          'provider'    => exec_provider,
          'timeout'     => exec_timeout,
        )
      }

      if !running
        it {
          is_expected.to contain_exec("stop #{_title} with docker").with(
            'command'     => "#{docker_command} stop --time=#{stop_wait_time} #{sanitised_title}",
            'onlyif'      => container_running_check,
            'environment' => exec_environment,
            'path'        => exec_path,
            'provider'    => exec_provider,
            'timeout'     => exec_timeout,
          )
        }
      else
        it {
          is_expected.to contain_exec("start #{_title} with docker").with(
            'command'     => "#{docker_command} start #{sanitised_title}",
            'unless'      => container_running_check,
            'environment' => exec_environment,
            'path'        => exec_path,
            'provider'    => exec_provider,
            'timeout'     => exec_timeout,
          )
        }
      end
    end
  else
    case service_provider_real
    when 'systemd'
      hasstatus          = true
      init_template      = 'docker/etc/systemd/system/docker-run.erb'
      initscript         = "/etc/systemd/system/#{service_prefix}#{sanitised_title}.service"
      mode               = '0644'
      startscript        = "/usr/local/bin/docker-run-#{sanitised_title}-start.sh"
      startstop_template = 'docker/usr/local/bin/docker-run.sh.epp'
      stopscript         = "/usr/local/bin/docker-run-#{sanitised_title}-stop.sh"
    when 'upstart'
      hasstatus          = true
      init_template      = 'docker/etc/init.d/docker-run.erb'
      initscript         = "/etc/init.d/#{service_prefix}#{sanitised_title}"
      mode               = '0750'
      startscript        = nil
      startstop_template = nil
      stopscript         = nil
    else
      hasstatus = _defaults['service_hasstatus']
    end

    _syslog_identifier = if syslog_identifier
                           syslog_identifier
                         else
                           "#{service_prefix}#{sanitised_title}"
                         end

    if ensure_value == 'absent'
      if _facts[:os]['family'] == 'windows'
        it {
          is_expected.to contain_exec("stop container #{service_prefix}#{sanitised_title}").with(
            'command'     => "#{docker_command} stop --time=#{stop_wait_time} #{sanitised_title}",
            'onlyif'      => "#{docker_command} inspect #{sanitised_title}",
            'environment' => exec_environment,
            'path'        => exec_path,
            'provider'    => exec_provider,
            'timeout'     => exec_timeout,
          ).that_notifies(
            "Exec[remove container #{service_prefix}#{sanitised_title}]",
          )
        }
      else
        it {
          is_expected.to contain_service("#{service_prefix}#{sanitised_title}").with(
            'ensure'    => false,
            'enable'    => false,
            'hasstatus' => hasstatus,
            'provider'  => service_provider_real,
          )
        }
      end

      it {
        is_expected.to contain_exec("remove container #{service_prefix}#{sanitised_title}").with(
          'command'     => "#{docker_command} rm -v #{sanitised_title}",
          'onlyif'      => "#{docker_command} inspect #{sanitised_title}",
          'environment' => exec_environment,
          'path'        => exec_path,
          'refreshonly' => true,
          'provider'    => exec_provider,
          'timeout'     => exec_timeout,
        )
      }

      if _facts[:os]['family'] != 'windows'
        it {
          is_expected.to contain_file("/etc/systemd/system/#{service_prefix}#{sanitised_title}.service").with(
            'ensure' => 'absent',
          )
        }

        if startscript
          it {
            is_expected.to contain_file(startscript).with(
              'ensure' => 'absent',
            )
          }
        end

        if stopscript
          it {
            is_expected.to contain_file(stopscript).with(
              'ensure' => 'absent',
            )
          }
        end
      else
        it {
          is_expected.to contain_file(cidfile).with(
            'ensure' => 'absent',
          )
        }
      end
    else
      if startscript
        it {
          is_expected.to contain_file(startscript).with(
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => docker_group,
            'mode'    => '0770',
          )
        }
      end

      if stopscript
        it {
          is_expected.to contain_file(stopscript).with(
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => docker_group,
            'mode'    => '0770',
          )
        }
      end

      it {
        is_expected.to contain_file(initscript).with(
          'ensure'  => 'file',
          'owner'   => 'root',
          'group'   => docker_group,
          'mode'    => mode,
        )
      }

      if manage_service
        if !running
          it {
            is_expected.to contain_service("#{service_prefix}#{sanitised_title}").with(
              'ensure'    => running,
              'enable'    => false,
              'hasstatus' => hasstatus,
            ).that_requires(
              "File[#{initscript}]",
            )
          }
        else
          if initscript == "/etc/init.d/#{service_prefix}#{sanitised_title}"
            transition_onlyif = [
              "/usr/bin/test -f /var/run/docker-#{sanitised_title}.cid &&",
              "/usr/bin/test -f /etc/init.d/#{service_prefix}#{sanitised_title}",
            ]

            it {
              is_expected.to contain_exec("/bin/sh /etc/init.d/#{service_prefix}#{sanitised_title} stop").with(
                'onlyif' => transition_onlyif.join(' '),
              ).that_comes_before(
                "File[/var/run/#{service_prefix}#{sanitised_title}.cid]",
              )

              is_expected.to contain_file("/var/run/#{service_prefix}#{sanitised_title}.cid").with(
                'ensure' => 'absent',
              ).that_comes_before(
                "File[#{initscript}]",
              )
            }
          end

          it {
            is_expected.to contain_service("#{service_prefix}#{sanitised_title}").with(
              'ensure'    => running,
              'enable'    => true,
              'provider'  => service_provider_real,
              'hasstatus' => hasstatus,
            ).that_requires(
              "File[#{initscript}]",
            )
          }

          if docker_service
            if docker_service.to_s == 'true'
              it {
                is_expected.to contain_service('docker').that_comes_before("Service[#{service_prefix}#{sanitised_title}]")
              }

              if restart_service_on_docker_refresh.to_s == 'true'
                it {
                  is_expected.to contain_service('docker').that_notifies("Service[#{service_prefix}#{sanitised_title}]")
                }
              end
            else
              it {
                is_expected.to contain_service('docker').with('name' => docker_service).that_comes_before("Service[#{service_prefix}#{sanitised_title}]")
              }

              if restart_service_on_docker_refresh.to_s == 'true'
                it {
                  is_expected.to contain_service('docker').with('name' => docker_service).that_notifies("Service[#{service_prefix}#{sanitised_title}]")
                }
              end
            end
          end
        end
      end

      if service_provider_real == 'systemd'
        it {
          is_expected.to contain_exec("docker-#{sanitised_title}-systemd-reload").with(
            'path'        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
            'command'     => 'systemctl daemon-reload',
            'refreshonly' => true,
          ).that_requires(
            [
              "File[#{initscript}]",
              "File[#{startscript}]",
              "File[#{stopscript}]",
            ],
          ).that_subscribes_to(
            [
              "File[#{initscript}]",
              "File[#{startscript}]",
              "File[#{stopscript}]",
            ],
          ).that_comes_before(
            "Service[#{service_prefix}#{sanitised_title}]",
          )
        }
      end
    end
  end
end
