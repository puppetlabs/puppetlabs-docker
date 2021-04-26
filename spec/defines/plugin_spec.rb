# frozen_string_literal: true

require 'spec_helper'

tests = {
  'foo/setting:latest' => {
    'settings' => [
      'VAR1=test',
      'VAR2=value',
    ],
  },
  'foo/disabled:latest' => {
    'enabled' => false,
  },
  'foo/force_remove:latest' => {
    'ensure'       => 'absent',
    'force_remove' => true,
  },
}

describe 'docker::plugin', type: :define do
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
            'ensure'                => 'present',
            'plugin_name'           => title,
            'enabled'               => true,
            'timeout'               => :undef,
            'plugin_alias'          => :undef,
            'disable_on_install'    => false,
            'disable_content_trust' => true,
            'grant_all_permissions' => true,
            'force_remove'          => true,
            'settings'              => [],
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

          if facts[:os]['family'] == 'windows'
            it {
              is_expected.to compile.and_raise_error(%r{Feature not implemented on windows.})
            }

            next
          end

          include_examples 'plugin', params, facts, defaults
        end
      end
    end
  end
end
