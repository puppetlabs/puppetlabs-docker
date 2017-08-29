require 'spec_helper'

describe 'docker::systemd_reload', :type => :class do

  let(:facts) { {
    :osfamily               => 'Debian',
    :operatingsystem        => 'Debian',
    :lsbdistid              => 'Debian',
    :lsbdistcodename        => 'wheezy',
    :kernelrelease          => '3.2.0-4-amd64',
    :operatingsystemrelease => '7.3',
    :operatingsystemmajrelease => '7',
  } }

  context 'with systems that have systemd' do
    it { should contain_exec('docker-systemd-reload').with(
    'path'       => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
    'command'     => 'systemctl daemon-reload',
    'refreshonly' => 'true'
    ) }
  end
end