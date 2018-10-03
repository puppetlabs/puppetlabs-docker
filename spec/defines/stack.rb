require 'spec_helper'

['Debian', 'Windows'].each do |osfamily|
  describe 'docker::stack', :type => :define do
    let(:title) { 'test_stack' }
    if osfamily == 'Debian'
      let(:facts) { {
        :osfamily                  => 'Debian',
        :operatingsystem           => 'Debian',
        :lsbdistid                 => 'Debian',
        :lsbdistcodename           => 'jessie',
        :kernelrelease             => '3.2.0-4-amd64',
        :operatingsystemmajrelease => '8',
      } }
    elsif osfamily == 'Windows'
      let(:facts) { {
        :osfamily                  => 'windows',
        :operatingsystem           => 'windows',
        :kernelrelease             => '10.0.14393',
        :operatingsystemmajrelease => '2016',
      } }
    end

    context 'Create stack with compose file' do
      let(:params) { {
        'stack_name' => 'foo', 	
        'compose_file' => '/tmp/docker-compose.yaml',
        'resolve_image' => 'always',
      } }
      it { should contain_exec('docker stack deploy').with_command(/docker stack deploy/) }
    end

    context 'with ensure => absent'  do
      let(:params) { {
        'ensure' => 'absent',
        'stack_name' => 'foo'} }
      it { should contain_exec('docker stack rm').with_command(/docker stack rm/) }
    end
  end
end