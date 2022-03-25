# frozen_string_literal: true

require 'spec_helper_acceptance'

volume_name = 'test-volume'

if os[:family] == 'windows'
  docker_args = 'docker_ee => true'
  command = '"/cygdrive/c/Program Files/Docker/docker"'
else
  docker_args = ''
  command = 'docker'
end

describe 'docker volume' do
  before(:all) do
    retry_on_error_matching(60, 5, %r{connection failure running}) do
      install_pp = "class { 'docker': #{docker_args} }"
      apply_manifest(install_pp, catch_failures: true)
    end
  end

  it 'exposes volume subcommand' do
    run_shell("#{command} volume --help", expect_failures: false)
  end

  context 'with a local volume described in Puppet' do
    it 'applies idempotently' do
      pp = <<-MANIFEST
        docker_volume { '#{volume_name}':
          ensure => present,
        }
      MANIFEST

      idempotent_apply(pp)
    end

    it 'has created a volume' do
      run_shell("#{command} volume inspect #{volume_name}", expect_failures: false)
    end

    after(:all) do
      run_shell("#{command} volume rm #{volume_name}")
    end
  end
end
