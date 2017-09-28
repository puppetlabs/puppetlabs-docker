require 'spec_helper'

describe 'docker::stack', :type => :define do
  let(:title) { 'test_stack' }
  let(:facts) { {
    :osfamily                  => 'Debian',
    :operatingsystem           => 'Debian',
    :lsbdistid                 => 'Debian',
    :lsbdistcodename           => 'jessie',
    :kernelrelease             => '3.2.0-4-amd64',
    :operatingsystemmajrelease => '8',
  } }

  context 'Create stack with compose file' do
    let(:params) { {
       'stack_name' => 'foo', 	
       'compose_file' => '/tmpdocker-compose.yaml',
    } }
    it { should contain_exec('docker stack deploy').with_command(/docker stack deploy/) }
  end

  context 'with ensure => absent'  do
    let(:params) { {
      'ensure' => 'absent',
      'stack_name' => 'foo'} }
    it { should contain_exec('docker stack rm').with_command(/docker stack rm/) }
  end


