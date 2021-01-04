# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with ensure => present and service create' => {
    'create'       => true,
    'service_name' => 'foo',
    'image'        => 'foo:bar',
    'publish'      => '80:80',
    'replicas'     => '5',
    'extra_params' => ['--update-delay 1m', '--restart-window 30s'],
    'env'          => ['MY_ENV=1', 'MY_ENV2=2'],
    'label'        => ['com.example.foo="bar"', 'bar=baz'],
    'mounts'       => ['type=bind,src=/tmp/a,dst=/tmp/a', 'type=bind,src=/tmp/b,dst=/tmp/b,readonly'],
    'networks'     => ['overlay'],
    'command'      => 'echo hello world',
  },
  'multiple services declaration' => {
    'service_name' => 'foo_2',
    'image'        => 'foo:bar',
    'command'      => ['echo', 'hello', 'world'],
  },
  'multiple publish ports and multiple networks' => {
    'service_name' => 'foo_3',
    'image'        => 'foo:bar',
    'publish'      => ['80:8080', '9000:9000'],
    'networks'     => ['foo_1', 'foo_2'],
  },
  'with ensure => present and service update' => {
    'create'       => false,
    'update'       => true,
    'service_name' => 'foo',
    'image'        => 'bar:latest',
  },
  'with ensure => present and service scale' => {
    'create'       => false,
    'scale'        => true,
    'service_name' => 'bar',
    'replicas'     => '5',
  },
  'with ensure => absent' => {
    'ensure'       => 'absent',
    'service_name' => 'foo',
  },
  'when adding a system user' => {
    'user' => ['user1'],
  },
}

describe 'docker::services', type: :define do
  on_supported_os.each do |os, os_facts|
    ##
    ## set some needed facts
    ##
    facts = if %r{windows}.match?(os)
              windows_facts.merge(os_facts)
            else
              os_facts
            end

    ##
    ## get defaults values from params
    ##
    defaults = get_defaults(facts)

    context "on #{os}" do
      tests.each do |title, local_params|
        context title do
          params = {
            'ensure'          => 'present',
            'create'          => true,
            'update'          => false,
            'scale'           => false,
            'detach'          => true,
            'tty'             => false,
            'env'             => [],
            'label'           => [],
            'extra_params'    => [],
            'image'           => :undef,
            'service_name'    => :undef,
            'publish'         => :undef,
            'replicas'        => :undef,
            'user'            => :undef,
            'workdir'         => :undef,
            'host_socket'     => :undef,
            'registry_mirror' => :undef,
            'mounts'          => :undef,
            'networks'        => :undef,
            'command'         => :undef,
          }.merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          let(:title) do
            'rspec_services'
          end

          if params['ensure'] == 'absent'
            if params['update'] || params['scale']
              it {
                is_expected.to compile.and_raise_error('When removing a service you can not update it.')
              }

              next
            end
          end

          include_examples 'services', 'rspec_services', params, facts, defaults
        end
      end
    end
  end
end
