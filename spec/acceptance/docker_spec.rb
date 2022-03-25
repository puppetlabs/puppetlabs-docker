# frozen_string_literal: true

require 'spec_helper_acceptance'

broken = false

registry_port = 5000

if os[:family] == 'windows'
  result = run_shell("ipconfig | findstr /i 'ipv4'")
  raise 'Could not retrieve ip address for Windows box' if result.exit_code != 0
  ip = result.stdout.split("\n")[0].split(':')[1].strip
  @windows_ip = ip
  docker_args = "docker_ee => true, extra_parameters => '\"insecure-registries\": [ \"#{@windows_ip}:5000\" ]'"
  root_dir = 'C:/Users/Administrator/AppData/Local/Temp'
  docker_registry_image = 'stefanscherer/registry-windows'
  docker_network = 'nat'
  registry_host = @windows_ip
  config_file = '/cygdrive/c/Users/Administrator/.docker/config.json'
  server_strip = "#{registry_host}_#{registry_port}"
  bad_server_strip = "#{registry_host}_5001"
  broken = true
else
  docker_args = ''
  docker_registry_image = 'registry'
  docker_network = 'bridge'
  registry_host = '127.0.0.1'
  server_strip = "#{registry_host}:#{registry_port}"
  bad_server_strip = "#{registry_host}:5001"
  config_file = '/root/.docker/config.json'
  root_dir = '/root'
end

describe 'docker' do
  package_name = 'docker-ce'
  service_name = 'docker'
  command = 'docker'

  before(:all) do
    install_pp = "class { 'docker': #{docker_args}}"
    apply_manifest(install_pp)
  end

  context 'When adding system user', win_broken: broken do
    let(:pp) do
      "
             class { 'docker': #{docker_args},
               docker_users => ['user1']
             }
      "
    end

    it 'the docker daemon' do
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stdout).not_to match(%r{docker-systemd-reload-before-service})
      end
    end
  end

  context 'When prepare_service_only param is set(prepare_service_only => true)', win_broken: broken do
    let(:pp) do
      "
        class { 'docker': #{docker_args} }
        docker::run { 'servercore':
          image                => 'hello-world:latest',
          prepare_service_only => true,
        }
      "
    end

    it 'creates the service without starting it' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'not start the service' do
      run_shell('systemctl status docker-servercore', expect_failures: true) do |r|
        expect(r.stdout.include?('Main PID')).to be false
      end
    end
  end

  context 'When prepare_service_only param is not set(prepare_service_only => false)', win_broken: broken do
    let(:pp) do
      "
        class { 'docker': #{docker_args} }
        docker::run { 'servercore':
          image => 'hello-world:latest',
        }
      "
    end

    it 'creates the service and start it' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'start the service' do
      run_shell('systemctl status docker-servercore', expect_failures: true) do |r|
        expect(r.stdout.include?('Main PID')).to be true
      end
    end
  end

  context 'When root_dir is set' do
    let(:pp) do
      "class { 'docker': #{docker_args}, root_dir => \"#{root_dir}\"}"
    end

    let(:shell_command) do
      if os[:family] == 'windows'
        'cat C:/ProgramData/docker/config/daemon.json'
      else
        'systemctl status docker'
      end
    end

    it 'works' do
      apply_manifest(pp, catch_failures: true)
      run_shell(shell_command) do |r|
        if os[:family] == 'windows'
          expect(r.stdout).to match(%r{\"data-root\": \"#{root_dir}\"})
        else
          expect(r.stdout).to match(%r{--data-root #{root_dir}})
        end
      end
    end
  end

  context 'with default parameters', win_broken: broken do
    let(:pp) do
      "
			class { 'docker':
        docker_users => [ 'testuser' ],
        #{docker_args}
			}
			docker::image { 'nginx': }
			docker::run { 'nginx':
				image   => 'nginx',
				net     => 'host',
				require => Docker::Image['nginx'],
			}
			docker::run { 'nginx2':
				image   => 'nginx',
				restart => 'always',
				require => Docker::Image['nginx'],
			}
    "
    end

    it 'applies with no errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'is idempotent' do
      if fetch_puppet_version > 5
        expect(docker_run_idempotent_apply(pp)).to be true
      else
        apply_manifest(pp, catch_changes: true)
      end
    end

    describe package(package_name) do
      it { is_expected.to be_installed }
    end

    describe service(service_name) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    it "#{command} version" do
      run_shell("#{command} version", expect_failures: false)
    end

    it "#{command} images" do
      result = run_shell("sudo #{command} images", expect_failures: false)
      expect(result[:exit_code]).to eq 0
      expect(result[:stdout]).to match %r{nginx}
    end

    it "#{command} inspect nginx" do
      run_shell("sudo #{command} inspect nginx", expect_failures: false)
    end

    it "#{command} inspect nginx2" do
      run_shell("sudo #{command} inspect nginx2", expect_failures: false)
    end

    it "#{command} ps --no-trunc | grep `cat /var/run/docker-nginx2.cid`" do
      result = run_shell("sudo #{command} ps --no-trunc | grep `cat /var/run/docker-nginx2.cid`", expect_failures: false)
      expect(result[:exit_code]).to eq 0
      expect(result[:stdout]).to match %r{nginx -g 'daemon off;'}
    end

    it 'netstat -tlndp' do
      result = run_shell('netstat -tlndp')
      expect(result[:exit_code]).to eq 0
      expect(result[:stdout]).to match %r{0\.0\.0\.0\:80}
    end

    it 'id testuser | grep docker' do
      result = run_shell('id testuser | grep docker')
      expect(result[:exit_code]).to eq 0
      expect(result[:stdout]).to match %r{docker}
    end
  end

  context 'When asked to have the latest image of something', win_broken: broken do
    let(:pp) do
      "
        class { 'docker':
          docker_users => [ 'testuser' ]
        }
	docker::image { 'busybox': ensure => latest }
    "
    end

    it 'applies with no errors' do
      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'When registry_mirror is set', win_broken: broken do
    let(:pp) do
      "
      class { 'docker':
        registry_mirror => 'http://testmirror.io'
      }
    "
    end

    it 'applies with no errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'has a registry mirror set' do
      run_shell('ps -aux | grep docker') do |r|
        expect(r.stdout).to match(%r{--registry-mirror=http:\/\/testmirror.io})
      end
    end
  end

  context 'When registry_mirror is array', win_broken: broken do
    let(:pp) do
      "
      class { 'docker':
        registry_mirror => ['http://testmirror1.io', 'http://testmirror2.io']
      }
    "
    end

    it 'applies with no errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'has all registry mirrors set' do
      run_shell('ps -aux | grep docker') do |r|
        expect(r.stdout).to match(%r{--registry-mirror=http:\/\/testmirror1.io})
        expect(r.stdout).to match(%r{--registry-mirror=http:\/\/testmirror2.io})
      end
    end
  end

  context 'registry' do
    let(:registry_address) do
      "#{registry_host}:#{registry_port}"
    end

    let(:registry_bad_address) do
      "#{registry_host}:5001"
    end

    it 'is able to run registry' do
      pp = <<-MANIFEST
        class { 'docker': #{docker_args}}
        docker::run { 'registry':
          image         => '#{docker_registry_image}',
          pull_on_start => true,
          restart       => 'always',
          net           => '#{docker_network}',
          ports         => '#{registry_port}:#{registry_port}',
        }
        MANIFEST
      retry_on_error_matching(60, 5, %r{connection failure running}) do
        apply_manifest(pp, catch_failures: true)
      end
      # avoid a race condition with the registry taking time to start
      # on some operating systems
      sleep 10
    end

    it 'is able to login to the registry', retry: 3, retry_wait: 10, win_broken: true do
      pp = <<-MANIFEST
        docker::registry { '#{registry_address}':
          username => 'username',
          password => 'password',
        }
      MANIFEST
      apply_manifest(pp, catch_failures: true)
      run_shell("grep #{registry_address} #{config_file}", expect_failures: false)
      run_shell("test -e \"#{root_dir}/registry-auth-puppet_receipt_#{server_strip}_root\"", expect_failures: false)
    end

    it 'is able to logout from the registry', win_broken: true do
      pp = <<-MANIFEST
        docker::registry { '#{registry_address}':
          ensure=> absent,
        }
      MANIFEST
      apply_manifest(pp, catch_failures: true)
      run_shell("grep #{registry_address} #{config_file}", expect_failures: true)
    end

    it 'does not create receipt if registry login fails', win_broken: true do
      pp = <<-MANIFEST
        docker::registry { '#{registry_bad_address}':
          username => 'username',
          password => 'password',
        }
      MANIFEST
      apply_manifest(pp, catch_failures: false)
      run_shell("grep #{registry_bad_address} #{config_file}", expect_failures: true)
      run_shell("test -e \"#{root_dir}/registry-auth-puppet_receipt_#{bad_server_strip}_root\"", expect_failures: true)
    end
  end
end
