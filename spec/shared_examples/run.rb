# frozen_string_literal: true

shared_examples 'run' do |title, params, facts, defaults|
  # after                             = params['after']
  # after_create                      = params['after_create']
  # after_service                     = params['after_service']
  # after_start                       = params['after_start']
  # after_stop                        = params['after_stop']
  # before_start                      = params['before_start']
  # before_stop                       = params['before_stop']
  command                           = params['command']
  cpuset                            = params['cpuset']
  # custom_unless                     = params['custom_unless']
  # depend_services                   = params['depend_services']
  # depends                           = params['depends']
  # detach                            = params['detach']
  disable_network                   = params['disable_network']
  dns                               = params['dns']
  dns_search                        = params['dns_search']
  docker_service                    = params['docker_service']
  ensure_value                      = params['ensure']
  env                               = params['env']
  env_file                          = params['env_file']
  expose                            = params['expose']
  extra_parameters                  = params['extra_parameters']
  # extra_systemd_parameters          = params['extra_systemd_parameters']
  health_check_cmd                  = params['health_check_cmd']
  health_check_interval             = params['health_check_interval']
  hostentries                       = params['hostentries']
  hostname                          = params['hostname']
  image                             = params['image']
  labels                            = params['labels']
  links                             = params['links']
  lxc_conf                          = params['lxc_conf']
  manage_service                    = params['manage_service']
  memory_limit                      = params['memory_limit']
  net                               = params['net']
  ports                             = params['ports']
  privileged                        = params['privileged']
  # pull_on_start                     = params['pull_on_start']
  read_only                         = params['read_only']
  # remain_after_exit                 = params['remain_after_exit']
  # remove_container_on_start         = params['remove_container_on_start']
  # remove_container_on_stop          = params['remove_container_on_stop']
  # remove_volume_on_start            = params['remove_volume_on_start']
  # remove_volume_on_stop             = params['remove_volume_on_stop']
  restart                           = params['restart']
  restart_on_unhealthy              = params['restart_on_unhealthy']
  # restart_service                   = params['restart_service']
  restart_service_on_docker_refresh = params['restart_service_on_docker_refresh']
  running                           = params['running']
  service_prefix                    = params['service_prefix']
  service_provider                  = params['service_provider']
  socket_connect                    = params['socket_connect']
  stop_wait_time                    = params['stop_wait_time']
  syslog_identifier                 = params['syslog_identifier']
  # systemd_restart                   = params['systemd_restart']
  tty                               = params['tty']
  use_name                          = params['use_name']
  username                          = params['username']
  volumes                           = params['volumes']
  volumes_from                      = params['volumes_from']
  docker_group                      = defaults['docker_group']

  if socket_connect != []
    sockopts       = [socket_connect].join(',')
    docker_command = "#{defaults['docker_command']} -H #{sockopts}"
  else
    docker_command = defaults['docker_command']
  end

  if use_name
    it {
      is_expected.to contain_notify("docker use_name warning: #{title}").with(
        'message'  => 'The use_name parameter is no-longer required and will be removed in a future release',
        'withpath' => true,
      )
    }
  end

  service_provider_real = case service_provider.to_s
                          when 'undef'
                            defaults['service_provider']
                          else
                            service_provider
                          end

  docker_run_flags = get_docker_run_flags(
    'cpuset' => [cpuset],
    'disable_network'       => disable_network,
    'dns_search'            => [dns_search],
    'dns'                   => [dns],
    'env_file'              => [env_file],
    'env'                   => [env],
    'expose'                => [expose],
    'extra_params' => [extra_parameters],
    'health_check_cmd'      => health_check_cmd,
    'health_check_interval' => health_check_interval,
    'hostentries'           => [hostentries],
    'hostname'              => hostname,
    'labels'                => [labels],
    'links'                 => [links],
    'lxc_conf'              => [lxc_conf],
    'memory_limit'          => memory_limit,
    'net'                   => net,
    'osfamily'              => facts[:os]['family'],
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

  sanitised_title = title.gsub('[^0-9A-Za-z.\-_]', '-')

  if facts[:os]['family'] == 'windows'
    exec_environment        = "PATH=#{facts['docker_program_files_path']}/Docker/;#{facts['docker_systemroot']}/System32/"
    exec_timeout            = 3000
    exec_path               = ["#{facts['docker_program_files_path']}/Docker/"]
    exec_provider           = 'powershell'
    cidfile                 = "#{facts['docker_user_temp_path']}/#{service_prefix}#{sanitised_title}.cid"
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
      is_expected.to contain_exec("Restart unhealthy container #{title} with docker").with(
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
        is_expected.to contain_exec("stop #{title} with docker").with(
          'command'     => "#{docker_command} stop --time=#{stop_wait_time} #{sanitised_title}",
          'onlyif'      => "#{docker_command} inspect #{sanitised_title}",
          'environment' => exec_environment,
          'path'        => exec_path,
          'provider'    => exec_provider,
          'timeout'     => exec_timeout,
        )

        is_expected.to contain_exec("remove #{title} with docker").with(
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

      # inspect = [
      #   "#{docker_command} inspect #{sanitised_title}",
      # ]

      # exec_unless = if custom_unless
      #                 custom_unless << inspect
      #               else
      #                 inspect
      #               end

      if facts[:puppetversion].to_i < 6
        it {
          is_expected.to contain_exec("run #{title} with docker").with(
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
            is_expected.to contain_exec("stop #{title} with docker").with(
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
            is_expected.to contain_exec("start #{title} with docker").with(
              'command'     => "#{docker_command} start #{sanitised_title}",
              'unless'      => container_running_check,
              'environment' => exec_environment,
              'path'        => exec_path,
              'provider'    => exec_provider,
              'timeout'     => exec_timeout,
            )
          }
        end
      else
        docker_params_changed_args = {
          'sanitised_title'   => sanitised_title,
          'osfamily'          => facts[:os]['family'],
          'command'           => run_with_docker_command.join(' '),
          'cidfile'           => cidfile,
          'image'             => image,
          'volumes'           => volumes,
          'ports'             => ports,
          'stop_wait_time'    => stop_wait_time,
          'container_running' => running,
          'logfile_path'      => facts[:os]['family'] == 'windows' ? facts['docker_user_temp_path'] : '/tmp',
        }

        detect_changes = get_docker_params_changed(docker_params_changed_args)

        it {
          is_expected.to contain_notify("#{title}_docker_params_changed").with(
            'message' => detect_changes,
          )
        }
      end
    end
  else
    case service_provider_real
    when 'systemd'
      hasstatus          = true
      initscript         = "/etc/systemd/system/#{service_prefix}#{sanitised_title}.service"
      mode               = '0644'
      startscript        = "/usr/local/bin/docker-run-#{sanitised_title}-start.sh"
      stopscript         = "/usr/local/bin/docker-run-#{sanitised_title}-stop.sh"
    when 'upstart'
      hasstatus          = true
      initscript         = "/etc/init.d/#{service_prefix}#{sanitised_title}"
      mode               = '0750'
      startscript        = nil
      stopscript         = nil
    else
      hasstatus = defaults['service_hasstatus']
    end

    _syslog_identifier = if syslog_identifier
                           syslog_identifier
                         else
                           "#{service_prefix}#{sanitised_title}"
                         end

    if ensure_value == 'absent'
      if facts[:os]['family'] == 'windows'
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

      if facts[:os]['family'] != 'windows'
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
