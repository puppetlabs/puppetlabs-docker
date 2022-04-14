# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with ensure => absent' => {
    'ensure' => 'absent',
    'version' => '17.06',
    'pass_hash' => 'test1234',
    'receipt' => false,
  },
  'with ensure => present' => {
    'ensure' => 'present',
    'version' => '17.06',
    'pass_hash' => 'test1234',
    'receipt' => false,
  },
  'with ensure => present and username => user1' => {
    'ensure' => 'present',
    'username' => 'user1',
    'version' => '17.06',
    'pass_hash' => 'test1234',
    'receipt' => false,
  },
  'with ensure => present and password => secret' => {
    'ensure' => 'present',
    'password' => 'secret',
    'version' => '17.06',
    'pass_hash' => 'test1234',
    'receipt' => false,
  },

  'with ensure => present and email => user1@example.io' => {
    'ensure' => 'present',
    'email' => 'user1@example.io',
    'version' => '17.06',
    'pass_hash' => 'test1234',
    'receipt' => false,
  },
  'with ensure => present and username => user1, and password => secret and email => user1@example.io' => {
    'ensure' => 'present',
    'username' => 'user1',
    'password' => 'secret',
    'email' => 'user1@example.io',
    'version' => '17.06',
    'pass_hash' => 'test1234',
    'receipt' => false,
  },
  'with ensure => present and username => user1, and password => secret and email => user1@example.io and version < 1.11.0' => {
    'ensure' => 'present',
    'username' => 'user1',
    'password' => 'secret',
    'email' => 'user1@example.io',
    'version' => '1.9.0',
    'pass_hash' => 'test1234',
    'receipt' => false,
  },
  'with username => user1, and password => secret' => {
    'username' => 'user1',
    'password' => 'secret',
    'version' => '17.06',
    'pass_hash' => 'test1234',
    'receipt' => false,
  },
  'with username => user1, and password => secret and local_user => testuser' => {
    'username' => 'user1',
    'password' => 'secret',
    'local_user' => 'testuser',
    'version' => '17.06',
    'pass_hash' => 'test1234',
    'receipt' => false,
  },
}

describe 'docker::registry', type: :define do
  on_supported_os.each do |os, os_facts|
    ##
    ## set some needed facts
    ##
    if %r{windows}.match?(os)
      facts = windows_facts.merge(
        'docker_home_dirs' => {
          'user' => '/home/user',
          'root' => '/root',
        },
      ).merge(os_facts)

      docker_params = {
        'docker_ee' => true,
      }
    else
      facts = {
        docker_home_dirs: {
          'user' => '/home/user',
          'root' => '/root',
        },
      }.merge(os_facts)

      docker_params = {}
    end

    ##
    ## get defaults values from params
    ##
    defaults = get_defaults(facts)

    context "on #{os}" do
      tests.each do |title, local_params|
        context title do
          params = {
            'server'     => title,
            'ensure'     => 'present',
            'username'   => :undef,
            'password'   => :undef,
            'pass_hash'  => :undef,
            'email'      => :undef,
            'local_user' => 'root',
            'version'    => defaults['version'],
            'receipt'    => true,
          }.merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          let(:title) do
            title
          end

          let :pre_condition do
            <<-MANIFEST
            function pw_hash($foo, $bar, $asdf) {
              return '$6$foobar$v8j5roVj0D8t.Ipwvk0RrMHiZfZRoBMeVQDywxUKFtdRI2EFRi2X6tbOigjpOsa9UDVzgIBtcl2ZEGcM.jnZZ.'
            }

            class { 'docker':
              version => "#{params['version']}",
              *       => #{docker_params},
            }
            MANIFEST
          end

          include_examples 'registry', title, params, facts, defaults
        end
      end
    end
  end
end
