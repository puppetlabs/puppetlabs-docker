# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with default valus' => {},
  'with ensure => absent' => {
    'ensure' => 'absent'
  },
  'with version => 1.7.0' => {
    'version' => '1.7.0'
  },
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
            'version' => defaults['compose_version'],
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
    end
  end
end
