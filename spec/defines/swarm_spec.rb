# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with ensure => present and swarm init' => {
    'init'           => true,
    'advertise_addr' => '192.168.1.1',
    'listen_addr'    => '192.168.1.1',
  },
  'with ensure => present and swarm init and default-addr-pool and default_addr_pool_mask_length' => {
    'init'                          => true,
    'advertise_addr'                => '192.168.1.1',
    'listen_addr'                   => '192.168.1.1',
    'default_addr_pool'             => ['30.30.0.0/16', '40.40.0.0/16'],
    'default_addr_pool_mask_length' => '24',
  },
  'with ensure => present and swarm join' => {
    'join'           => true,
    'advertise_addr' => '192.168.1.1',
    'listen_addr'    => '192.168.1.1',
    'token'          => 'foo',
    'manager_ip'     => '192.168.1.2',
  },
  'with ensure => absent' => {
    'ensure'         => 'absent',
    'join'           => true,
    'advertise_addr' => '192.168.1.1',
    'listen_addr'    => '192.168.1.1',
    'token'          => 'foo',
    'manager_ip'     => '192.168.1.2',
  },
}

describe 'docker::swarm', type: :define do
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
            'ensure'                        => 'present',
            'init'                          => false,
            'join'                          => false,
            'advertise_addr'                => :undef,
            'autolock'                      => false,
            'cert_expiry'                   => :undef,
            'default_addr_pool'             => :undef,
            'default_addr_pool_mask_length' => :undef,
            'dispatcher_heartbeat'          => :undef,
            'external_ca'                   => :undef,
            'force_new_cluster'             => false,
            'listen_addr'                   => :undef,
            'max_snapshots'                 => :undef,
            'snapshot_interval'             => :undef,
            'token'                         => :undef,
            'manager_ip'                    => :undef,
          }.merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          let(:title) do
            'rspec_swarm'
          end

          include_examples 'swarm', 'rspec_swarm', params, facts, defaults
        end
      end
    end
  end
end
