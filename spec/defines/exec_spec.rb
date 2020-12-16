# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with default values' => {
  },
  'when running detached' => {
    'detach' => true,
  },
  'when running with tty' => {
    'tty' => true,
  },
  'when running with interactive' => {
    'interactive' => true,
  },
  'when running with onlyif "running"' => {
    'interactive' => true,
    'onlyif'      => 'running',
  },
  'when running without onlyif custom command' => {
    'interactive' => true,
    'onlyif'      => 'custom',
  },
  'when running without onlyif' => {
    'interactive' => true,
  },
  'when running with unless' => {
    'interactive' => true,
    'unless'      => 'some_command arg1',
  },
  'when running without unless' => {
    'interactive' => true,
  },
  'with title that need sanitisation' => {
    'detach'        => true,
    'sanitise_name' => true,
  },
  'with environment variables passed to exec' => {
    'env' => [
      'FOO=BAR',
      'FOO2=BAR2',
    ],
  },
}

describe 'docker::exec', type: :define do
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
            'command'       => '/bin/echo foo',
            'container'     => 'some_conainer_name',
            'detach'        => false,
            'env'           => [],
            'interactive'   => false,
            'onlyif'        => :undef,
            'refreshonly'   => false,
            'sanitise_name' => true,
            'tty'           => false,
            'unless'        => :undef,
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

          include_examples 'exec', params, facts, defaults
        end
      end
    end
  end
end
