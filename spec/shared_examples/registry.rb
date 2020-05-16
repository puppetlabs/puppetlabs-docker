shared_examples 'registry' do |_title, _params, _facts, _defaults|
  server       = _params['server']
  ensure_value = _params['ensure']
  username     = _params['username']
  password     = _params['password']
  pass_hash    = _params['pass_hash']
  email        = _params['email']
  local_user   = _params['local_user']
  version      = _params['version']
  receipt      = _params['receipt']

  docker_command = _defaults['docker_command']

  if _facts[:os]['family'] == 'windows'
    exec_environment = ["PATH=#{_facts['docker_program_files_path']}/Docker/"]
    exec_timeout     = 3000
    exec_path        = ["#{_facts['docker_program_files_path']}/Docker/"]
    exec_provider    = 'powershell'
    password_env     = '$env:password'
    exec_user        = nil
  else
    exec_environment = []
    exec_path        = ['/bin', '/usr/bin']
    exec_timeout     = 0
    exec_provider    = nil
    password_env     = "\${password}"
    exec_user        = local_user
    local_user_home  = _facts[:docker_home_dirs][local_user]
  end

  if ensure_value == 'present'
    if username != :undef && password != :undef && email != :undef && version != :undef && version =~ %r{1[.][1-9]0?}
      auth_cmd         = "#{docker_command} login -u '#{username}' -p \"#{password_env}\" -e '#{email}' #{server}"
      auth_environment = "password=#{password}"
    elsif username != :undef && password != :undef
      auth_cmd         = "#{docker_command} login -u '#{username}' -p \"#{password_env}\" #{server}"
      auth_environment = "password=#{password}"
    else
      auth_cmd         = "#{docker_command} login #{server}"
      auth_environment = ''
    end
  else
    auth_cmd         = "#{docker_command} logout #{server}"
    auth_environment = ''
  end

  docker_auth = "#{_title}#{auth_environment}#{auth_cmd}#{local_user}"

  exec_env = if auth_environment != ''
               exec_environment << auth_environment << "docker_auth=#{docker_auth}"
             else
               exec_environment << "docker_auth=#{docker_auth}"
             end

  if receipt
    if _facts[:os]['family'] != 'windows'
      server_strip     = server.tr('/', '_')
      local_user_strip = local_user.gsub('[-_]', '')

      _pass_hash = case pass_hash
                   when :undef
                     pw_hash(docker_auth, 'SHA-512', local_user_strip)
                   else
                     pass_hash
                   end

      _auth_command = "#{auth_cmd} || rm -f \"/#{local_user_home}/registry-auth-puppet_receipt_#{server_strip}_#{local_user}\""

      it {
        is_expected.to contain_file('/${local_user_home}/registry-auth-puppet_receipt_${server_strip}_${local_user}').with(
          'ensure'  => ensure_value,
          'content' => _pass_hash,
          'owner'   => local_user,
          'group'   => local_user,
        ).that_notifies(
          "Exec[#{_title} auth]",
        )
      }
    else
      server_strip  = server.gsub('[/:]', '_')
      passfile      = "#{_facts['docker_user_temp_path']}/registry-auth-puppet_receipt_#{server_strip}_#{local_user}"
      _auth_command = "if (-not (#{auth_cmd})) { Remove-Item -Path #{passfile} -Force -Recurse -EA SilentlyContinue; exit 0 } else { exit 0 }"

      if ensure_value == 'absent'
        it {
          is_expected.to contain_file(passfile).with(
            'ensure' => ensure_value,
          ).that_notifies(
            "Exec[#{_title} auth]",
          )
        }
      elsif ensure_value == 'present'
        it {
          is_expected.to contain_exec(compute - hash).with(
            # 'command'     => template('docker/windows/compute_hash.ps1.erb'),
            'environment' => exec_env,
            'provider'    => exec_provider,
            'logoutput'   => true,
            # 'unless'      => template('docker/windows/check_hash.ps1.erb'),
          ).that_notifies(
            "Exec[#{_title} auth]",
          )
        }
      end
    end
  else
    _auth_command = auth_cmd
  end

  it {
    is_expected.to contain_exec("#{_title} auth").with(
      'environment' => exec_env,
      'command'     => _auth_command,
      'user'        => exec_user,
      'path'        => exec_path,
      'timeout'     => exec_timeout,
      'provider'    => exec_provider,
      'refreshonly' => receipt,
    )
  }
end
