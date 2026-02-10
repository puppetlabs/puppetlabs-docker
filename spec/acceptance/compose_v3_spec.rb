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

  context 'Creating compose projects with services having restart: no' do
    before(:all) do
      # Create a compose file with one service having restart: no
      compose_content = <<-YAML
version: '3.8'
services:
  db:
    image: mysql:5.7
    restart: always
  web:
    image: nginx
    restart: no
YAML
      create_remote_file(hosts, "#{tmp_path}/docker-compose-restart-no.yml", compose_content)
    end

    let(:install_pp) do
      <<-MANIFEST
        docker_compose { 'restart_test':
          compose_files => ['#{tmp_path}/docker-compose-restart-no.yml'],
          ensure => present,
        }
      MANIFEST
    end

    it 'is idempotent' do
      idempotent_apply(install_pp)
    end

    it 'finds the running service but ignores the restart: no service' do
      # Assuming the compose file has one service with restart: always and one with restart: no
      run_shell('docker inspect restart_test-db_1', expect_failures: false)
      # The web service with restart: no should not be running
      run_shell('docker inspect restart_test-web_1', expect_failures: true)
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
