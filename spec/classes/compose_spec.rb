require 'spec_helper'

describe 'docker::compose', :type => :class do

  let(:facts) { {
    :kernel                 => 'Linux',
    :osfamily               => 'Debian',
    :operatingsystem        => 'Debian',
    :lsbdistid              => 'Debian',
    :lsbdistcodename        => 'wheezy',
    :kernelrelease          => '3.2.0-4-amd64',
    :operatingsystemrelease => '7.3',
    :operatingsystemmajrelease => '7',
  } }
   context 'with defaults for all parameters' do
    it { should compile.with_all_deps }
    it { should contain_exec('Install Docker Compose 1.9.0').with(
      'path'    => '/usr/bin/',
      'cwd'     => '/tmp',
      'command' => "curl -s -L  https://github.com/docker/compose/releases/download/1.9.0/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose-1.9.0",
      'creates' => "/usr/local/bin/docker-compose-1.9.0",
      'require' => 'Package[curl]'
      )}
    it { should contain_file('/usr/local/bin/docker-compose-1.9.0').with(
      'owner'   => 'root',
      'mode'    => '0755',
      'require' => 'Exec[Install Docker Compose 1.9.0]'
      )}
    it { should contain_file('/usr/local/bin/docker-compose').with(
      'ensure'   => 'link',
      'target'   => '/usr/local/bin/docker-compose-1.9.0',
      'require'  => 'File[/usr/local/bin/docker-compose-1.9.0]'
      )}
  end

  context 'with ensure => absent' do
    let (:params) { { :ensure => 'absent' } }
    it { should contain_file('/usr/local/bin/docker-compose-1.9.0').with_ensure('absent') }
    it { should contain_file('/usr/local/bin/docker-compose').with_ensure('absent') }
  end
end