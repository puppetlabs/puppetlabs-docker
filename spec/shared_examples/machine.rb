# frozen_string_literal: true

shared_examples 'machine' do |_params, _facts, _defaults|
  ensure_value = _params['ensure']
  version      = _params['version']
  install_path = _params['install_path']
  proxy        = _params['proxy']
  url          = _params['url']
  curl_ensure  = _params['curl_ensure']

  if _facts[:os]['family'] == 'windows'
    file_extension = '.exe'
    file_owner     = 'Administrator'
  else
    file_extension = ''
    file_owner     = 'root'
  end

  docker_machine_location           = "#{install_path}/docker-machine#{file_extension}"
  docker_machine_location_versioned = "#{install_path}/docker-machine-#{version}#{file_extension}"

  if ensure_value == 'present'
    docker_machine_url = case url
                         when :undef
                           "https://github.com/docker/machine/releases/download/v#{version}/docker-machine-#{_facts[:kernel]}-x86_64#{file_extension}"
                         else
                           url
                         end

    proxy_opt = case proxy
                when :undef
                  ''
                else
                  "--proxy #{proxy}"
                end

    if _facts[:os]['family'] == 'windows'
      docker_download_command = "if (Invoke-WebRequest #{docker_machine_url} #{proxy_opt} -UseBasicParsing -OutFile \"#{docker_machine_location_versioned}\") { exit 0 } else { exit 1 }"

      it {
        is_expected.to contain_exec("Install Docker Machine #{version}").with(
          # 'command'  => template('docker/windows/download_docker_machine.ps1.erb'),
          'provider' => 'powershell',
          'creates'  => docker_machine_location_versioned,
        )

        is_expected.to contain_file(docker_machine_location).with(
          'ensure'  => 'link',
          'target'  => docker_machine_location_versioned,
        ).that_requires(
          "Exec[Install Docker Machine #{version}]",
        )
      }
    else
      if curl_ensure
        it {
          is_expected.to contain_package('curl')
        }
      end

      it {
        is_expected.to contain_exec("Install Docker Machine #{version}").with(
          'path'    => '/usr/bin/',
          'cwd'     => '/tmp',
          'command' => "curl -s -S -L #{proxy_opt} #{docker_machine_url} -o #{docker_machine_location_versioned}",
          'creates' => docker_machine_location_versioned,
        ).that_requires(
          'Package[curl]',
        )

        is_expected.to contain_file(docker_machine_location_versioned).with(
          'owner' => file_owner,
          'mode'  => '0755',
        ).that_requires(
          "Exec[Install Docker Machine #{version}]",
        )

        is_expected.to contain_file(docker_machine_location).with(
          'ensure'  => 'link',
          'target'  => docker_machine_location_versioned,
        ).that_requires(
          "File[#{docker_machine_location_versioned}]",
        )
      }
    end
  else
    is_expected.to contain_file(docker_machine_location_versioned).with(
      'ensure' => 'absent',
    )

    is_expected.to contain_file(docker_machine_location).with(
      'ensure' => 'absent',
    )
  end
end
