# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with default value' => {
  },
  'with ensure => absent' => {
    'ensure' => 'absent',
  },
  'with ensure => absent and force => true' => {
    'ensure' => 'absent',
    'force'  => true,
  },
  'with ensure => absent and image_tag => precise' => {
    'ensure'    => 'absent',
    'image_tag' => 'precise',
  },
  'with docker_file => Dockerfile' => {
    'docker_file' => 'Dockerfile',
  },
  'with ensure => present and docker_file => Dockerfile' => {
    'ensure'      => 'present',
    'docker_file' => 'Dockerfile',
  },
  'with docker_dir => /tmp/docker_images/test1 and docker_file => /tmp/docker_images/test1/Dockerfile_altbuild' => {
    'docker_dir'  => '/tmp/docker_images/test1',
    'docker_file' => '/tmp/docker_images/test1/Dockerfile_altbuild',
  },
  'with docker_dir => /tmp/docker_images/test1' => {
    'docker_dir'   => '/tmp/docker_images/test1',
  },
  'with ensure => present and docker_dir => /tmp/docker_images/test1' => {
    'ensure'     => 'present',
    'docker_dir' => '/tmp/docker_images/test1',
  },
  'with ensure => present and image_tag => precise' => {
    'ensure'    => 'present',
    'image_tag' => 'precise',
  },
  'with ensure => present and image_digest => sha256:deadbeef' => {
    'ensure'       => 'present',
    'image_digest' => 'sha256:deadbeef',
  },
  'with ensure => present and image_tag => precise and docker_file => Dockerfile' => {
    'ensure'      => 'present',
    'image_tag'   => 'precise',
    'docker_file' => 'Dockerfile',
  },
  'with ensure => present and image_tag => precise and docker_dir => /tmp/docker_images/test1' => {
    'ensure'     => 'present',
    'image_tag'  => 'precise',
    'docker_dir' => '/tmp/docker_images/test1',
  },
  'with docker_tar => /tmp/docker_tars/test1.tar' => {
    'docker_tar' => '/tmp/docker_tars/test1.tar',
  },
  'with ensure => present and docker_tar => /tmp/docker_tars/test1.tar' => {
    'ensure'     => 'present',
    'docker_tar' => '/tmp/docker_tars/test1.tar',
  },
  'with docker_file => Dockerfile and docker_tar => /tmp/docker_tars/test1.tar' => {
    'docker_file' => 'Dockerfile',
    'docker_tar'  => '/tmp/docker_tars/test1.tar',
  },
  'with docker_tar => /tmp/docker_tars/test1.tar and docker_dir => /tmp/docker_images/test1' => {
    'docker_tar' => '/tmp/docker_tars/test1.tar',
    'docker_dir' => '/tmp/docker_images/test1',
  },
  'with image_digest => sha256:deadbeef and docker_file => Dockerfile' => {
    'image_digest' => 'sha256:deadbeef',
    'docker_file'  => 'Dockerfile',
  },
  'with image_digest => sha256:deadbeef and docker_dir => /tmp/docker_images/test1' => {
    'image_digest' => 'sha256:deadbeef',
    'docker_dir'   => '/tmp/docker_images/test1',
  },
  'with image_digest => sha256:deadbeef and docker_tar => /tmp/docker_tars/test1.tar' => {
    'image_digest' => 'sha256:deadbeef',
    'docker_tar' => '/tmp/docker_tars/test1.tar',
  },
  'with ensure => latest' => {
    'ensure' => 'latest',
  },
  'with ensure => latest and image_tag => precise' => {
    'ensure'    => 'latest',
    'image_tag' => 'precise',
  },
  'with ensure => latest and image_digest => sha256:deadbeef' => {
    'ensure'       => 'latest',
    'image_digest' => 'sha256:deadbeef',
  },
}

describe 'docker::image', type: :define do
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
            'image'        => 'base',
            'image_tag'    => :undef,
            'image_digest' => :undef,
            'force'        => false,
            'docker_file'  => :undef,
            'docker_dir'   => :undef,
            'docker_tar'   => :undef,
          }.merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          let(:title) do
            params['image']
          end

          if params['docker_file'] != :undef && params['docker_tar'] != :undef
            it {
              is_expected.to compile.and_raise_error(%r{docker::image must not have both \$docker_file and \$docker_tar set})
            }

            next
          end

          if params['docker_dir'] != :undef && params['docker_tar'] != :undef
            it {
              is_expected.to compile.and_raise_error(%r{docker::image must not have both \$docker_dir and \$docker_tar set})
            }

            next
          end

          if params['image_digest'] != :undef && params['docker_file'] != :undef
            it {
              is_expected.to compile.and_raise_error(%r{docker::image must not have both \$image_digest and \$docker_file set})
            }

            next
          end

          if params['image_digest'] != :undef && params['docker_dir'] != :undef
            it {
              is_expected.to compile.and_raise_error(%r{docker::image must not have both \$image_digest and \$docker_dir set})
            }

            next
          end

          if params['image_digest'] != :undef && params['docker_tar'] != :undef
            it {
              is_expected.to compile.and_raise_error(%r{docker::image must not have both \$image_digest and \$docker_tar set})
            }

            next
          end

          include_examples 'image', params, facts, defaults
        end
      end
    end
  end
end
