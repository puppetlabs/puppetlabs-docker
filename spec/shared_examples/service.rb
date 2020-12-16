# frozen_string_literal: true

shared_examples 'service' do |params, facts|
  # dns_array              = [params['dns']]
  # dns_search_array       = [params['dns_search']]
  # extra_parameters_array = [params['extra_parameters']]
  # labels_array           = [params['labels']]
  # shell_values_array     = [params['shell_values']]
  # tcp_bind_array         = [params['tcp_bind']]

  service_config = if params['service_config'] != :undef
                     params['service_config']
                   elsif facts[:os]['family'] == 'Debian'
                     "/etc/default/#{params['service_name']}"
                   else
                     nil
                   end

  manage_service = case params['manage_service']
                   when true
                     'Service[docker]'
                   else
                     []
                   end

  if facts[:os]['family'] == 'RedHat'
    it {
      is_expected.to contain_file(params['storage_setup_file']).with(
        'ensure'  => 'file',
        'force'   => true,
        'before'  => manage_service,
        'notify'  => manage_service,
      )
    }
  end

  if facts[:os]['family'] == 'windows'
    [
      "#{facts['docker_program_data_path']}/docker/",
      "#{facts['docker_program_data_path']}/docker/config/",
    ].each do |dir|
      it {
        is_expected.to contain_file(dir).with_ensure('directory')
      }
    end
  end

  case params['service_provider']
  when 'systemd'
    it {
      is_expected.to contain_file('/etc/systemd/system/docker.service.d').with_ensure('directory')
    }

    if params['service_overrides_template']
      it {
        is_expected.to contain_file('/etc/systemd/system/docker.service.d/service-overrides.conf').with(
          'ensure'  => 'file',
          # 'content' => template($service_overrides_template),
          'before'  => manage_service,
        ).that_notifies(
          'Exec[docker-systemd-reload-before-service]',
        )
      }
    end

    if params['socket_override']
      it {
        is_expected.to contain_file('/etc/systemd/system/docker.socket.d').with_ensure('directory')
      }

      it {
        is_expected.to contain_file('/etc/systemd/system/docker.socket.d/socket-overrides.conf').with(
          'ensure' => 'file',
          # 'content' => template($socket_overrides_template),
        ).that_comes_before(
          manage_service,
        ).that_notifies(
          'Exec[docker-systemd-reload-before-service]',
        )
      }
    end

    it {
      is_expected.to contain_exec('docker-systemd-reload-before-service').with(
        'path'        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
        'command'     => 'systemctl daemon-reload > /dev/null',
        'refreshonly' => true,
      ).that_notifies(
        manage_service,
      )
    }
  when 'upstart'
    it {
      is_expected.to contain_file('/etc/init.d/docker').with(
        'ensure' => 'link',
        'target' => '/lib/init/upstart-job',
        'force'  => true,
      ).that_notifies(
        manage_service,
      )
    }
  end

  if params['storage_config'] != :undef
    it {
      is_expected.to contain_file(params['storage_config']).with(
        'ensure'  => 'file',
        'force'   => true,
      ).that_notifies(
        manage_service,
      )
    }
  end

  if service_config
    it {
      is_expected.to contain_file(service_config).with(
        'ensure'  => 'file',
        'force'   => true,
      ).that_notifies(
        manage_service,
      )
    }
  end

  if params['manage_service']
    if facts[:os]['family'] == 'windows'
      it {
        is_expected.to contain_reboot('pending_reboot').with(
          'when'    => 'pending',
          'onlyif'  => 'component_based_servicing',
          'timeout' => 1,
        )
      }
    end

    it {
      hasstatus = if params['service_hasstatus'] == :undef
                    nil
                  else
                    params['service_hasstatus']
                  end

      hasrestart = if params['service_hasrestart'] == :undef
                     nil
                   else
                     params['service_hasrestart']
                   end

      provider = if params['service_provider'] == :undef
                   nil
                 else
                   params['service_provider']
                 end

      is_expected.to contain_service('docker').with(
        'ensure'     => params['service_state'],
        'name'       => params['service_name'],
        'enable'     => params['service_enable'],
        'hasstatus'  => hasstatus,
        'hasrestart' => hasrestart,
        'provider'   => provider,
      )
    }
  end
end
