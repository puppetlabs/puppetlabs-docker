# frozen_string_literal: true

shared_examples 'system_user' do |user, group|
  docker_group = group

  it {
    is_expected.to contain_user(user).with(
      'ensure' => 'present',
    ).that_comes_before("Exec[docker-system-user-#{user}]")
  }

  it {
    is_expected.to contain_exec("docker-system-user-#{user}").with(
      'command' => "/usr/sbin/usermod -aG #{docker_group} #{user}",
      'unless'  => "/bin/cat /etc/group | grep '^#{docker_group}:' | grep -qw #{user}",
    )
  }
end
