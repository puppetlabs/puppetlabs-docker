# frozen_string_literal: true

require 'spec_helper_acceptance'

if os[:family] == 'windows'
  install_dir = '/cygdrive/c/Program Files/Docker'
  file_extension = '.exe'
  docker_args = 'docker_ee => true'
  tmp_path = 'C:/cygwin64/tmp'
  test_container = if %r{2019|2022}.match?(os[:release])
                     'nanoserver'
                   else
                     'nanoserver-sac2016'
                   end
else
  docker_args = ''
  install_dir = '/usr/local/bin'
  file_extension = ''
  tmp_path = '/tmp'
  test_container = 'debian'
end

describe 'docker compose' do
  before(:all) do
    retry_on_error_matching(60, 5, %r{connection failure running}) do
      install_code = <<-code
        class { 'docker': #{docker_args} }
        class { 'docker::compose':
          version => '1.23.2',
        }
      code
      apply_manifest(install_code, catch_failures: true)
    end
  end

  context 'Creating compose v3 projects', win_broken: true do
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
      run_shell('docker-compose --help', expect_failures: false)
    end

    it 'finds a docker container' do
      run_shell('docker inspect web_compose_test_1', expect_failures: false)
    end
  end

  context 'creating compose projects with multi compose files', win_broken: true do
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
      run_shell("docker inspect web1_compose_test_1 | grep #{test_container}", acceptable_exit_codes: [0])
    end
  end

  context 'Destroying project with multiple compose files', win_broken: true do
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
      run_shell('docker inspect web1_compose_test_1', expect_failures: true)
    end
  end

  context 'Requesting a specific version of compose' do
    let(:version) do
      '1.21.2'
    end

    it 'is idempotent' do
      pp = <<-MANIFEST
        class { 'docker::compose':
          version => '#{version}',
        }
      MANIFEST
      idempotent_apply(pp)
    end

    it 'has installed the requested version' do
      if os[:family] == 'redhat' && os[:release].to_i == 7
        run_shell('sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose')
        run_shell('sudo chmod +x /usr/bin/docker-compose')
      end
      run_shell('docker-compose --version', expect_failures: false) do |r|
        expect(r.stdout).to match(%r{#{version}})
      end
    end
  end

  context 'Removing docker compose' do
    let(:version) do
      '1.21.2'
    end

    it 'is idempotent' do
      pp = <<-MANIFEST
        class { 'docker::compose':
          ensure  => absent,
          version => '#{version}',
        }
      MANIFEST
      idempotent_apply(pp)
    end

    it 'has removed the relevant files' do
      run_shell("test -e \"#{install_dir}/docker-compose#{file_extension}\"", expect_failures: true)
      run_shell("test -e \"#{install_dir}/docker-compose-#{version}#{file_extension}\"", expect_failures: true)
    end

    after(:all) do
      install_pp = <<-MANIFEST
        class { 'docker': #{docker_args}}
        class { 'docker::compose': }
      MANIFEST
      apply_manifest(install_pp, catch_failures: true)
    end
  end
end
