shared_examples 'config' do |_params, _facts|
  docker_users = _params['docker_users']

  it {
    is_expected.to contain_class('docker::config')
  }

  unless docker_users.empty?
    docker_users.each do |user|
      if _facts[:os]['family'] =~ %r{windows}
        it {
          is_expected.to contain_docker__windows_account(user)
        }
      else
        it {
          is_expected.to contain_docker__system_user(user)
        }

        include_examples 'system_user', user, _params['docker_group']
      end
    end
  end
end
