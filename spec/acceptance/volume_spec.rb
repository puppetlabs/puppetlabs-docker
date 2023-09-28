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
    install_pp = "class { 'docker': #{docker_args} }"
    apply_manifest_wrapper(install_pp)
  end

  it 'exposes volume subcommand' do
    run_shell("#{command} volume --help", expect_failures: false)
  end

  context 'with a local volume described in Puppet' do
    after(:all) do
      run_shell_wrapper("#{command} volume rm #{volume_name}")
    end

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
  end
end
