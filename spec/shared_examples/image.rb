# frozen_string_literal: true

shared_examples 'image' do |_params, _facts, _defaults|
  docker_command = _defaults['docker_command']
  docker_dir     = _params['docker_dir']
  docker_file    = _params['docker_file']
  docker_tar     = _params['docker_tar']
  ensure_value   = _params['ensure']
  force          = _params['force']
  image          = _params['image']
  image_digest   = _params['image_digest']
  image_tag      = _params['image_tag']

  if _facts[:os]['family'] == 'windows'
    update_docker_image_template = 'docker/windows/update_docker_image.ps1.erb'
    update_docker_image_path     = "#{_facts['docker_user_temp_path']}/update_docker_image.ps1"
    exec_environment             = "PATH=#{_facts['docker_program_files_path']}/Docker/"
    exec_timeout                 = 3000
    update_docker_image_owner    = nil
    exec_path                    = ["#{_facts['docker_program_files_path']}/Docker/"]
    exec_provider                = 'powershell'
  else
    update_docker_image_template = 'docker/update_docker_image.sh.erb'
    update_docker_image_path     = '/usr/local/bin/update_docker_image.sh'
    update_docker_image_owner    = 'root'
    exec_environment             = 'HOME=/root'
    exec_path                    = ['/bin', '/usr/bin']
    exec_timeout                 = 0
    exec_provider                = nil
  end

  it {
    is_expected.to contain_file(update_docker_image_path).with(
      'ensure'  => 'present',
      'owner'   => update_docker_image_owner,
      'group'   => update_docker_image_owner,
      'mode'    => '0555',
      # 'content' => template($update_docker_image_template),
    )
  }

  image_force = if force
                  '-f '
                else
                  ''
                end

  if image_tag != :undef
    image_arg     = "#{image}:#{image_tag}"
    image_remove  = "#{docker_command} rmi #{image_force}#{image}:#{image_tag}"
    image_find    = "#{docker_command} images -q #{image}:#{image_tag}"
  elsif image_digest != :undef
    image_arg     = "#{image}@#{image_digest}"
    image_remove  = "#{docker_command} rmi #{image_force}#{image}:#{image_digest}"
    image_find    = "#{docker_command} images -q #{image}@#{image_digest}"
  else
    image_arg     = image
    image_remove  = "#{docker_command} rmi #{image_force}#{image}"
    image_find    = "#{docker_command} images -q #{image}"
  end

  _image_find = if _facts[:os]['family'] == 'windows'
                  "If (-not (#{image_find}) ) { Exit 1 }"
                else
                  "#{image_find} | grep ."
                end

  image_install = if docker_dir != :undef && docker_file != :undef
                    "#{docker_command} build -t #{image_arg} -f #{docker_file} #{docker_dir}"
                  elsif docker_dir != :undef
                    "#{docker_command} build -t #{image_arg} #{docker_dir}"
                  elsif docker_file != :undef
                    if _facts[:os]['family'] == 'windows'
                      "Get-Content #{docker_file} -Raw | #{docker_command} build -t #{image_arg} -"
                    else
                      "#{docker_command} build -t #{image_arg} - < #{docker_file}"
                    end
                  elsif docker_tar != :undef
                    "#{docker_command} load -i #{docker_tar}"
                  elsif _facts[:os]['family'] == 'windows'
                    "& #{update_docker_image_path} -DockerImage #{image_arg}"
                  else
                    "#{update_docker_image_path} #{image_arg}"
                  end

  if ensure_value == 'absent'
    it {
      is_expected.to contain_exec(image_remove).with(
        'path'        => exec_path,
        'environment' => exec_environment,
        'onlyif'      => _image_find,
        'provider'    => exec_provider,
        'timeout'     => exec_timeout,
        'logoutput'   => true,
      )
    }
  elsif ensure_value == 'latest' || image_tag == 'latest'
    it {
      is_expected.to contain_notify("Check if image #{image_arg} is in-sync").with(
        'noop' => false,
      ).that_notifies(
        "Exec[#{image_install}]",
      )

      is_expected.to contain_exec(image_install).with(
        'environment' => exec_environment,
        'path'        => exec_path,
        'timeout'     => exec_timeout,
        'returns'     => ['0', '2'],

        'provider'    => exec_provider,
        'logoutput'   => true,
      ).that_requires(
        "File[#{update_docker_image_path}]",
      ).that_notifies(
        "Exec[echo 'Update of #{image_arg} complete']",
      )

      is_expected.to contain_exec("echo 'Update of #{image_arg} complete'").with(
        'environment' => exec_environment,
        'path'        => exec_path,
        'timeout'     => exec_timeout,

        'provider'    => exec_provider,
        'logoutput'   => true,
        'refreshonly' => true,
      ).that_requires(
        "File[#{update_docker_image_path}]",
      )
    }
  elsif ensure_value == 'present'
    it {
      is_expected.to contain_exec(image_install).with(
        'unless'      => _image_find,
        'environment' => exec_environment,
        'path'        => exec_path,
        'timeout'     => exec_timeout,
        'returns'     => ['0', '2'],
        'provider'    => exec_provider,
        'logoutput'   => true,
      ).that_requires(
        "File[#{update_docker_image_path}]",
      )
    }
  end
end
