# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with ensure => present' => {
    'ensure' => 'present',
  },
  'with ensure => absent' => {
    'ensure' => 'absent',
  },
}

describe 'docker::images', type: :class do
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
              'ensure'       => 'present',
              'image_tag'    => :undef,
              'image_digest' => :undef,
              'force'        => false,
              'docker_file'  => :undef,
              'docker_dir'   => :undef,
              'docker_tar'   => :undef,
            },
          }

          params.each do |key, values|
            values.merge!(local_params.merge('image' => key))

            let(:facts) do
              facts
            end

            let(:params) do
              {
                'images' => {
                  key => values,
                },
              }
            end

            include_examples 'image', values, facts, defaults

            it {
              is_expected.to contain_docker__image(key)
            }
          end
        end
      end
    end
  end
end
