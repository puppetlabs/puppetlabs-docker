shared_examples 'service' do |_params, _facts|
  dns_array              = [_params['dns']]
  dns_search_array       = [_params['dns_search']]
  extra_parameters_array = [_params['extra_parameters']]
  labels_array           = [_params['labels']]
  shell_values_array     = [_params['shell_values']]
  tcp_bind_array         = [_params['tcp_bind']]

  _service_config = if _params['service_config'] != :undef
                      _params['service_config']
                    else
                      if _facts[:os]['family'] == 'Debian'
                        "/etc/default/#{_params['service_name']}"
                      else
                        nil
                      end
                    end

  _manage_service = case _params['manage_service']
                    when true
                      'Service[docker]'
                    else
                      []
                    end

  if _facts[:os]['family'] == 'RedHat'
    it {
      is_expected.to contain_file(_params['storage_setup_file']).with(
        'ensure'  => 'file',
        'force'   => true,
        'before'  => _manage_service,
        'notify'  => _manage_service,
      )
    }
  end

  if _facts[:os]['family'] == 'windows'
    [
      "#{_facts['docker_program_data_path']}/docker/",
      "#{_facts['docker_program_data_path']}/docker/config/",
    ].each do |dir|
      it {
        is_expected.to contain_file(dir).with_ensure('directory')
      }
    end
  end

  case _params['service_provider']
  when 'systemd'
    it {
      is_expected.to contain_file('/etc/systemd/system/docker.service.d').with_ensure('directory')
    }

    if _params['service_overrides_template']
      it {
        is_expected.to contain_file('/etc/systemd/system/docker.service.d/service-overrides.conf').with(
          'ensure'  => 'file',
          # 'content' => template($service_overrides_template),
          'before'  => _manage_service,
        ).that_notifies(
          'Exec[docker-systemd-reload-before-service]',
        )
      }
    end

    if _params['socket_override']
      it {
        is_expected.to contain_file('/etc/systemd/system/docker.socket.d').with_ensure('directory')
      }

      it {
        is_expected.to contain_file('/etc/systemd/system/docker.socket.d/socket-overrides.conf').with(
          'ensure' => 'file',
          # 'content' => template($socket_overrides_template),
        ).that_comes_before(
          _manage_service,
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
        _manage_service,
      )
    }
  when 'upstart'
    it {
      is_expected.to contain_file('/etc/init.d/docker').with(
        'ensure' => 'link',
        'target' => '/lib/init/upstart-job',
        'force'  => true,
      ).that_notifies(
        _manage_service,
      )
    }
  end

  if _params['storage_config'] != :undef
    it {
      is_expected.to contain_file(_params['storage_config']).with(
        'ensure'  => 'file',
        'force'   => true,
      ).that_notifies(
        _manage_service,
      )
    }
  end

  if _service_config
    it {
      is_expected.to contain_file(_service_config).with(
        'ensure'  => 'file',
        'force'   => true,
      ).that_notifies(
        _manage_service,
      )
    }
  end

  if _params['manage_service']
    if _facts[:os]['family'] == 'windows'
      it {
        is_expected.to contain_reboot('pending_reboot').with(
          'when'    => 'pending',
          'onlyif'  => 'component_based_servicing',
          'timeout' => 1,
        )
      }
    end

    it {
      _hasstatus = if _params['service_hasstatus'] == :undef
                     nil
                   else
                     _params['service_hasstatus']
                   end

      _hasrestart = if _params['service_hasrestart'] == :undef
                      nil
                    else
                      _params['service_hasrestart']
                    end

      _provider = if _params['service_provider'] == :undef
                    nil
                  else
                    _params['service_provider']
                  end

      is_expected.to contain_service('docker').with(
        'ensure'     => _params['service_state'],
        'name'       => _params['service_name'],
        'enable'     => _params['service_enable'],
        'hasstatus'  => _hasstatus,
        'hasrestart' => _hasrestart,
        'provider'   => _provider,
      )
    }
  end
end
