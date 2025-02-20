# frozen_string_literal: true

require 'spec_helper_acceptance'

tmp_path = '/tmp'
test_container = 'debian'

describe 'docker compose', :win_broken do
  before(:all) do
    retry_on_error_matching(60, 5, %r{connection failure running}) do
      install_code = <<-CODE
        class { 'docker': }
        class { 'docker::compose': }
      CODE
      apply_manifest(install_code, catch_failures: true)
    end
  end

  context 'Creating compose v3 projects' do
    let(:install_pp) do
      <<-MANIFEST
        docker_compose { 'web':
          compose_files => ['#{tmp_path}/docker-compose-v3.yml'],
          ensure => present,
          scale => {
            compose_test => 2
          }
        }
      MANIFEST
    end

    it 'is idempotent' do
      idempotent_apply(install_pp)
    end

    it 'has docker compose installed' do
      run_shell('docker compose --help', expect_failures: false)
    end

    it 'finds a docker container' do
      run_shell('docker inspect web-compose_test_1', expect_failures: false)
    end
  end

  context 'creating compose projects with multi compose files' do
    before(:all) do
      install_pp = <<-MANIFEST
        docker_compose { 'web1':
          compose_files => ['#{tmp_path}/docker-compose-v3.yml', '#{tmp_path}/docker-compose-override-v3.yml'],
          ensure => present,
          scale => {
            compose_test => 2
          }
        }
      MANIFEST

      apply_manifest(install_pp, catch_failures: true)
    end

    it "finds container with #{test_container} tag" do
      run_shell("docker inspect web1-compose_test_1 | grep #{test_container}", acceptable_exit_codes: [0])
    end
  end

  context 'Destroying project with multiple compose files' do
    let(:destroy_pp) do
      <<-MANIFEST
        docker_compose { 'web1':
          compose_files => ['#{tmp_path}/docker-compose-v3.yml', '#{tmp_path}/docker-compose-override-v3.yml'],
          ensure => absent,
        }
      MANIFEST
    end

    before(:all) do
      install_pp = <<-MANIFEST
        docker_compose { 'web1':
          compose_files => ['#{tmp_path}/docker-compose-v3.yml', '#{tmp_path}/docker-compose-override-v3.yml'],
          ensure => present,
        }
      MANIFEST

      apply_manifest(install_pp, catch_failures: true)
    end

    it 'is idempotent' do
      idempotent_apply(destroy_pp)
    end

    it 'does not find a docker container' do
      run_shell('docker inspect web1-compose_test_1', expect_failures: true)
    end
  end

  context 'Requesting a specific version of compose' do
    let(:version) do
      '2.25.0'
    end

    it 'is idempotent' do
      pp = <<-MANIFEST
        class { 'docker::compose':
          version => '#{version}-*',
        }
      MANIFEST
      idempotent_apply(pp)
    end

    it 'has installed the requested version' do
      command = 'docker compose version'

      run_shell(command, expect_failures: false) do |r|
        expect(r.stdout).to match(%r{#{version}})
      end
    end
  end

  context 'Removing docker compose' do
    after(:all) do
      install_pp = <<-MANIFEST
        class { 'docker': }
        class { 'docker::compose': }
      MANIFEST
      apply_manifest(install_pp, catch_failures: true)
    end

    it 'is idempotent' do
      pp = <<-MANIFEST
        class { 'docker::compose':
          ensure  => absent,
        }
      MANIFEST
      idempotent_apply(pp)
    end

    it 'has removed the compose plugin' do
      run_shell('docker compose version', expect_failures: true)
    end
  end
end
