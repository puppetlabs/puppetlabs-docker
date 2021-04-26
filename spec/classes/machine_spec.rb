# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with default value' => {
  },
}

describe 'docker::machine', type: :class do
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
            'version'      => defaults['machine_version'],
            'install_path' => defaults['machine_install_path'],
            'proxy'        => :undef,
            'url'          => :undef,
            'curl_ensure'  => defaults['curl_ensure'],
          }.merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          if params['proxy'] != :undef
            unless '^((http[s]?)?:\/\/)?([^:^@]+:[^:^@]+@|)([\da-z\.-]+)\.([\da-z\.]{2,6})(:[\d])?([\/\w \.-]*)*\/?$'.match?(params['proxy'])
              it {
                is_expected.to compile.and_raise_error(%r{})
              }

              next
            end
          end

          include_examples 'machine', params, facts, defaults
        end
      end
    end
  end
end
