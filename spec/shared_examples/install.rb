# frozen_string_literal: true

shared_examples 'install' do |_params, _facts|
  values = get_values_init(_params, _facts)

  ensure_value = if _params['version'] != :undef && _params['ensure'] != 'absent'
                   _params['version']
                 else
                   _params['ensure']
                 end

  if _params['manage_package']
    docker_hash = if _params['repo_opt'] == :undef
                    {}
                  else
                    { 'install_options' => _params['repo_opt'] }
                  end

    if _params['package_source'] != :undef
      it {
        is_expected.to contain_class('docker::install')
      }

      case _params['package_source']
      when 'docker-engine'
        it {
          is_expected.to contain_package('docker').with(
            {
              'ensure'   => ensure_value,
              'source'   => _params['package_source'],
              'name'     => _params['docker_engine_package_name'],
            }.merge(docker_hash),
          )
        }
      when 'docker-ce'
        it {
          is_expected.to contain_package('docker').with(
            {
              'ensure'   => ensure_value,
              'source'   => _params['package_source'],
              'name'     => _params['docker_ce_package_name'],
            }.merge(docker_hash),
          )
        }
        it {
          is_expected.to contain_package('docker-ce-cli').with(
            {
              'ensure'   => ensure_value,
              'source'   => _params['package_source'],
              'name'     => _params['docker_ce_cli_package_name'],
            }.merge(docker_hash),
          )
        }
      end
    elsif _facts[:os]['family'] != 'windows'
      it {
        is_expected.to contain_package('docker').with(
          'ensure' => ensure_value,
          'name'   => values['docker_package_name'],
        )
      }

      if ensure_value == 'absent'
        _params['dependent_packages'].each do |dependent_package|
          it {
            is_expected.to contain_package(dependent_package).with(
              'ensure' => ensure_value,
            )
          }
        end
      end
    elsif ensure_value == 'absent'
      it {
        if _params['version'] != :undef
          is_expected.to contain_exec('remove-docker-package').with(
            'command' => %r{-RequiredVersion #{_params['version']}},
          )
        end

        is_expected.to contain_exec('remove-docker-package').with(
          'command'   => %r{\$package=Uninstall-Package #{_params['docker_ee_package_name']} -ProviderName \$dockerProviderName -Force},
          'provider'  => 'powershell',
          'unless'    => %r{\$package=Get-Package #{_params['docker_ee_package_name']} -ProviderName \$dockerProviderName -ErrorAction Ignore},
          'logoutput' => true,
        )
      }
    else
      if _params['package_location']
        it {
          is_expected.to contain_exec('install-docker-package').with(
            'command'   => %r{Invoke-webrequest -UseBasicparsing -Outfile \$dockerLocation "#{_params['docker_download_url']}"},
            'provider'  => 'powershell',
            'unless'    => %r{\$webRequest = \[System.Net.HttpWebRequest\]::Create("#{_params['docker_download_url']}");},
            'logoutput' => true,
          ).that_notifies(
            'Exec[service-restart-on-failure]',
          )
        }
      else
        it {
          if _params['nuget_package_provider_version'] != :undef
            is_expected. to contain_exec(
              'install-docker-package',
            ).with_command(
              %r{-RequiredVersion #{_params['nuget_package_provider_version']}},
            ).with_unless(
              %r{\$module.Version.ToString\(\) -ne "#{_params['nuget_package_provider_version']}"},
            )
          end

          if _params['docker_msft_provider_version'] != :undef
            is_expected. to contain_exec(
              'install-docker-package',
            ).with_command(
              %r{-RequiredVersion #{_params['docker_msft_provider_version']}},
            ).with_unless(
              %r{\$provider.Version.ToString\(\) -ne "#{_params['docker_msft_provider_version']}"},
            )
          end

          if _params['version'] != :undef
            is_expected.to contain_exec(
              'install-docker-package',
            ).with_command(
              %r{-RequiredVersion #{_params['version']}},
            ).with_unless(
              %r{\$package.Version.ToString\(\) -notmatch  "#{_params['version']}"},
            )
          end

          is_expected.to contain_exec('install-docker-package').with(
            'command'   => %r{\$package=Install-Package #{_params['docker_ee_package_name']} -ProviderName \$dockerProviderName -Force},
            'provider'  => 'powershell',
            'unless'    => %r{\$package=Get-Package #{_params['docker_ee_package_name']} -ProviderName \$dockerProviderName},
            'logoutput' => true,
          ).that_notifies(
            'Exec[service-restart-on-failure]',
          )
        }
      end

      it {
        is_expected.to contain_exec('service-restart-on-failure').with(
          'command'     => 'SC.exe failure Docker reset= 432000 actions= restart/30000/restart/60000/restart/60000',
          'refreshonly' => true,
          'logoutput'   => true,
          'provider'    => 'powershell',
        )
      }
    end
  end
end
