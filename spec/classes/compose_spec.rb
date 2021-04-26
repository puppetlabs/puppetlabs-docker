# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with default valus' => {
  },
  'with ensure => absent' => {
    'ensure' => 'absent',
  },
  'with version => 1.7.0' => {
    'version' => '1.7.0',
  },
  'when proxy is provided' => {
    'version' => '1.7.0',
    'proxy'   => 'http://proxy.example.org:3128/',
  },
  'when proxy is not a http proxy' => {
    'proxy'   => 'this is not a URL',
  },
  'when proxy contains username and password' => {
    'version' => '1.7.0',
    'proxy'   => 'http://user:password@proxy.example.org:3128/',
  },
  'when proxy IP is provided' => {
    'version' => '1.7.0',
    'proxy'   => 'http://10.10.10.10:3128/',
  },
  'when base_url is provided' => {
    'version'  => '1.7.0',
    'base_url' => 'http://example.org',
  },
  'when raw_url is provided' => {
    'version'  => '1.7.0',
    'raw_url' => 'http://example.org',
  },
}

describe 'docker::compose', type: :class do
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
            'ensure'       => 'present',
            'version'      => defaults['compose_version'],
            'install_path' => defaults['compose_install_path'],
            'symlink_name' => defaults['compose_symlink_name'],
            'proxy'        => :undef,
            'base_url'     => defaults['compose_base_url'],
            'raw_url'      => :undef,
            'curl_ensure'  => defaults['curl_ensure'],
          }.merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          if params['proxy'] != :undef
            unless %r{^((http[s]?)?:\/\/)?([^:^@]+:[^:^@]+@|)([\da-z\.-]+)\.([\da-z\.]{2,6})(:[\d])?([\/\w \.-]*)*\/?$}.match?(params['proxy'])
              it {
                is_expected.to compile.and_raise_error(%r{does not match})
              }

              next
            end
          end

          include_examples 'compose', params, facts
        end
      end
    end
  end
end
