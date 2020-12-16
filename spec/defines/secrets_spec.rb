# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with ensure present' => {
    'secret_name' => 'test_secret',
    'secret_path' => '/root/secret.txt',
    'label'       => ['test'],
  },
  'with ensure absent' => {
    'ensure'      => 'absent',
    'secret_name' => 'test_secret',
  },
}

describe 'docker::secrets', type: :define do
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
            'ensure'      => 'present',
            'label'       => [],
            'secret_name' => :undef,
            'secret_path' => :undef,
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

          include_examples 'secrets', title, params, facts, defaults
        end
      end
    end
  end
end
