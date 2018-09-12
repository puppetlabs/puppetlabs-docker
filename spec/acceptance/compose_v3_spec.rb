require 'spec_helper_acceptance'

if fact('osfamily') == 'windows'
  install_dir = '/cygdrive/c/Program Files/Docker'
  file_extension = '.exe'
  docker_args = 'docker_ee => true'
  tmp_path = 'C:/cygwin64/tmp'
else
  install_dir = '/usr/local/bin'
  file_extension = ''
  docker_args = ''
  tmp_path = '/tmp'
end

describe 'docker compose' do 
  before(:all) do
    retry_on_error_matching(60, 5, /connection failure running/) do
      install_code = <<-code
        class { 'docker': #{docker_args} }
        class { 'docker::compose': 
          version => '1.21.0',
        }
      code
      apply_manifest(install_code, :catch_failures=>true)
    end
  end

  context 'Creating compose v3 projects' do
    it 'should have docker compose installed' do
      shell('docker-compose --help', :acceptable_exit_codes => [0])
    end

    before(:all) do
      @install = <<-code
docker_compose { '#{tmp_path}/docker-compose-v3.yml':
  ensure => present,
}
      code
      apply_manifest(@install, :catch_failures=>true)
    end

    it 'should be idempotent' do
      apply_manifest(@install, :catch_changes=>true)
    end

    it 'should find a docker container' do
      shell('docker inspect tmp_compose_test_1', :acceptable_exit_codes => [0])
    end
  end

  context 'multi compose file override' do
    before(:all) do
      @install = <<-code
docker_compose { 'override_test':
  compose_files => ['#{tmp_path}/docker-compose-v3.yml', '#{tmp_path}/docker-compose-override-v3.yml'],
  ensure => present,
}
      code
      apply_manifest(@install, :catch_failures=>true)
    end

    it 'should be idempotent' do 
      apply_manifest(@install, :catch_changes=>true)
    end

    it 'should find container with debian tag' do
      shell('docker inspect tmp_compose_test', :acceptable_exit_codes => [0])
    end
   end
      

  context 'Destroying compose v3 projects' do
    before(:all) do
      install = <<-code
docker_compose { '#{tmp_path}/docker-compose-v3.yml':
  ensure => present,
}
      code
      apply_manifest(install, :catch_failures=>true)
      @uninstall = <<-code
docker_compose { '#{tmp_path}/docker-compose-v3.yml':
  ensure => absent,
}
      code
      apply_manifest(@uninstall, :catch_failures=>true)
    end

    it 'should be idempotent' do
      apply_manifest(@uninstall, :catch_changes=>true)
    end

    it 'should not find a docker container' do
      shell('docker inspect tmp_compose_test_1', :acceptable_exit_codes => [1])
    end
  end

  context 'Requesting a specific version of compose' do
    before(:all) do
      @version = '1.21.2'
      @pp = <<-code
        class { 'docker::compose':
          version => '#{@version}',
        }
      code
      apply_manifest(@pp, :catch_failures=>true)
    end

    it 'should be idempotent' do
      apply_manifest(@pp, :catch_changes=>true)
    end

    it 'should have installed the requested version' do
      shell('docker-compose --version', :acceptable_exit_codes => [0]) do |r|
        expect(r.stdout).to match(/#{@version}/)
      end
    end
  end

  context 'Removing docker compose' do
    before(:all) do
      @version = '1.21.2'
      @pp = <<-code
        class { 'docker::compose':
          ensure  => absent,
          version => '#{@version}',
        }
      code
      apply_manifest(@pp, :catch_failures=>true)
    end

    it 'should be idempotent' do
      apply_manifest(@pp, :catch_changes=>true)
    end

    it 'should have removed the relevant files' do
      shell("test -e \"#{install_dir}/docker-compose#{file_extension}\"", :acceptable_exit_codes => [1])
      shell("test -e \"#{install_dir}/docker-compose-#{@version}#{file_extension}\"", :acceptable_exit_codes => [1])
    end

    after(:all) do
      install_code = <<-code
        class { 'docker': #{docker_args}}
        class { 'docker::compose': }
      code
      apply_manifest(install_code, :catch_failures=>true)
    end
  end
end
