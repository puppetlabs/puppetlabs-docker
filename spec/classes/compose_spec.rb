# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with default valus' => {},
  'with ensure => absent' => {
    'ensure' => 'absent'
  },
  'with version => 1.7.0' => {
    'version' => '1.7.0'
  }
}

describe 'docker::compose', type: :class do
  on_supported_os.each do |os, os_facts|
    ##
    ## set some needed facts
    ##
    facts = if os.include?('windows')
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
            'ensure' => 'present',
            'version' => defaults['compose_version']
          }.merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          include_examples 'compose', params, facts
        end
      end

      next unless facts[:os]['family'] == 'Archlinux'

      context 'with default values on Arch Linux' do
        let(:facts) { facts }

        it {
          expect(subject).to contain_package('docker-compose-plugin').with(
            ensure: 'present',
            name: 'docker-compose',
          ).without_require
        }
      end

      context 'with docker and compose absent on Arch Linux' do
        let(:facts) { facts }
        let(:params) { { 'ensure' => 'absent' } }
        let(:pre_condition) { "class { 'docker': ensure => absent }" }

        # the docker-compose package depends on docker, so pacman must remove it first
        it { is_expected.to contain_package('docker-compose-plugin').with_ensure('absent').that_comes_before('Package[docker]') }
      end

      context 'with version => 1.7.0 on Arch Linux' do
        let(:facts) { facts }
        let(:params) { { 'version' => '1.7.0' } }

        it {
          expect(subject).to compile.and_raise_error(%r{Installing a specific Docker Compose version is not supported on Arch Linux})
        }
      end
    end
  end
end
