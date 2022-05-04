# frozen_string_literal: true

require 'spec_helper'

tests = {
  'network-present' => {
    'ensure'   => 'present',
    'driver'   => 'overlay',
    'subnet'   => '192.168.1.0/24',
    'gateway'  => '192.168.1.1',
    'ip_range' => '192.168.1.4/32',
  },
  'network-absent' => {
    'ensure'   => 'absent',
    'driver'   => 'overlay',
    'subnet'   => '192.168.1.0/24',
    'gateway'  => '192.168.1.1',
    'ip_range' => '192.168.1.4/32',
  },
}

describe 'docker::networks', type: :class do
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
          params = local_params

          let(:facts) do
            facts
          end

          let(:params) do
            {
              'networks' => {
                title => local_params,
              },
            }
          end

          it {
            is_expected.to contain_docker_network(title).with(
              'ensure'   => params['ensure'],
              'driver'   => params['driver'],
              'subnet'   => params['subnet'],
              'gateway'  => params['gateway'],
              'ip_range' => params['ip_range'],
            )
          }

          it { is_expected.to have_docker_network_resource_count(1) }
        end
      end

      context 'with no params' do
        it { is_expected.to have_docker_network_resource_count(0) }
      end
    end
  end
end
