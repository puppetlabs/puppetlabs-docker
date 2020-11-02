require 'spec_helper_acceptance'

broken = false
command = 'docker'
network_name = 'test-network'

if os[:family] == 'windows'
  puts 'Not implemented on Windows'
  broken = true
elsif os[:name] == 'ubuntu' && os[:release][:full] == '14.04'
  docker_args = "version => '18.06.1~ce~3-0~ubuntu'"
else
  docker_args = ''
end

describe 'docker network', win_broken: broken do
  before(:all) do
    install_pp = "class { 'docker': #{docker_args}}"
    apply_manifest(install_pp, catch_failures: true)
  end

  it "#{command} network --help" do
    run_shell("#{command} network --help", expect_failures: false)
  end

  context 'with a local bridge network described in Puppet' do
    after(:all) do
      run_shell("#{command} network rm #{network_name}")
    end

    it 'is idempotent' do
      pp = <<-MANIFEST
        docker_network { '#{network_name}':
          ensure => present,
        }
      MANIFEST
      idempotent_apply(pp)
    end

    it 'has created a network' do
      run_shell("#{command} network inspect #{network_name}", expect_failures: false)
    end
  end
end
