# frozen_string_literal: true

require 'spec_helper'

tests = {
  'foo/enabled:latest' => {
    'enabled' => true,
  },
  'foo/disabled:latest' => {
    'enabled' => false,
  },
}

describe 'docker::plugins', type: :class do
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
            'base' => {
              'ensure'                => 'present',
              'enabled'               => true,
              'timeout'               => :undef,
              'plugin_alias'          => :undef,
              'disable_on_install'    => false,
              'disable_content_trust' => true,
              'grant_all_permissions' => true,
              'force_remove'          => true,
              'settings'              => [],
            },
          }

          params.each do |key, values|
            values.merge!(local_params.merge('plugin_name' => key))

            let(:facts) do
              facts
            end

            let(:params) do
              {
                'plugins' => {
                  key => values,
                },
              }
            end

            if facts[:os]['family'] == 'windows'
              it {
                is_expected.to compile.and_raise_error(%r{Feature not implemented on windows.})
              }

              next
            end

            include_examples 'plugin', values, facts, defaults

            it {
              is_expected.to contain_docker__plugin(key)
            }
          end
        end
      end
    end
  end
end
