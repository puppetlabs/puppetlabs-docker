# frozen_string_literal: true

require 'spec_helper'

tests = {
  'create stack with compose file' => {
    'stack_name'    => 'foo',
    'compose_files' => ['/tmp/docker-compose.yaml'],
    'resolve_image' => 'always',
  },
  'create stack with multiple compose files' => {
    'stack_name'    => 'foo',
    'compose_files' => ['/tmp/docker-compose.yaml', '/tmp/docker-compose-2.yaml'],
    'resolve_image' => 'always',
  },
  'with prune' => {
    'stack_name'    => 'foo',
    'compose_files' => ['/tmp/docker-compose.yaml'],
    'prune'         => true,
  },
  'with ensure => absent' => {
    'ensure'     => 'absent',
    'stack_name' => 'foo',
  },
}

describe 'docker::stack', type: :define do
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
            'ensure'             => 'present',
            'stack_name'         => :undef,
            'bundle_file'        => :undef,
            'compose_files'      => :undef,
            'prune'              => false,
            'with_registry_auth' => false,
            'resolve_image'      => :undef,
          }.merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          let(:title) do
            'rspec_stack'
          end

          include_examples 'stack', 'rspec_stack', params, facts, defaults
        end
      end
    end
  end
end
