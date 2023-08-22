# frozen_string_literal: true

require 'spec_helper'
# Need to write test casees here
tests = {
  'with default value' => {}
}

describe 'docker::machine', type: :class do
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
            'version' => defaults['machine_version'],
            'install_path' => defaults['machine_install_path'],
            'proxy' => :undef,
            'url' => :undef,
            'curl_ensure' => defaults['curl_ensure']
          }.merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          # Need to write check condition for params['proxy']
          # The block commented below currently has no test case, if in future more test cases are added to this spec file, please refer to spec/classes/compose_spec.rb and implement as required here.
          # if title == 'when proxy is not a http proxy'
          #  it 'raises an error for invalid proxy URL' do
          #    is_expected.to compile.and_raise_error(
          #      %r{parameter 'proxy' expects an undef value or a match for Pattern},
          #    )
          #  end
          # else
          # include_examples 'machine', params, facts, defaults
          # end
          include_examples 'machine', params, facts, defaults
        end
      end
    end
  end
end
