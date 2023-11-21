# frozen_string_literal: true

shared_examples 'compose' do |_params, _facts|
  ensure_value = _params['ensure']
  version      = _params['version']
  install_path = _params['install_path']
  symlink_name = _params['symlink_name']
  proxy        = _params['proxy']
  base_url     = _params['base_url']
  raw_url      = _params['raw_url']
  curl_ensure  = _params['curl_ensure']

  if _facts[:os]['family'] == 'windows'
    file_extension = '.exe'
    file_owner     = 'Administrator'
  else
    file_extension = ''
    file_owner     = 'root'
  end

  docker_compose_location           = "#{install_path}/#{symlink_name}#{file_extension}"
  docker_compose_location_versioned = "#{install_path}/docker-compose-#{version}#{file_extension}"

  if ensure_value == 'present'
    docker_compose_url = if raw_url == :undef
                           "#{base_url}/#{version}/docker-compose-#{_facts[:kernel]}-x86_64#{file_extension}"
                         else
                           raw_url
                         end

    proxy_opt = if proxy == :undef
                  ''
                else
                  "--proxy #{proxy}"
                end

    if _facts[:os]['family'] == 'windows'
      docker_download_command = "if (Invoke-WebRequest #{docker_compose_url} #{proxy_opt} -UseBasicParsing -OutFile \"#{docker_compose_location_versioned}\") { exit 0 } else { exit 1 }"

      it {
        expect(subject).to contain_exec("Install Docker Compose #{version}").with(
          'provider' => 'powershell',
          'creates' => docker_compose_location_versioned,
        )

        expect(subject).to contain_file(docker_compose_location).with(
          'ensure' => 'link',
          'target' => docker_compose_location_versioned,
        ).that_requires(
          "Exec[Install Docker Compose #{version}]",
        )
      }
    else
      if curl_ensure
        it {
          expect(subject).to contain_package('curl')
        }
      end

      it {
        expect(subject).to contain_exec("Install Docker Compose #{version}").with(
          'path' => '/usr/bin/',
          'cwd' => '/tmp',
          'command' => "curl -s -S -L #{proxy_opt} #{docker_compose_url} -o #{docker_compose_location_versioned}",
          'creates' => docker_compose_location_versioned,
        ).that_requires(
          'Package[curl]',
        )

        expect(subject).to contain_file(docker_compose_location_versioned).with(
          'owner' => file_owner,
          'mode' => '0755',
        ).that_requires(
          "Exec[Install Docker Compose #{version}]",
        )

        expect(subject).to contain_file(docker_compose_location).with(
          'ensure' => 'link',
          'target' => docker_compose_location_versioned,
        ).that_requires(
          "File[#{docker_compose_location_versioned}]",
        )
      }
    end
  else

    it {
      expect(subject).to contain_file(docker_compose_location_versioned).with(
        'ensure' => 'absent',
      )

      expect(subject).to contain_file(docker_compose_location).with(
        'ensure' => 'absent',
      )
    }
  end
end
