require 'spec_helper_acceptance'

broken = false
command = 'docker'
plugin_name = 'vieux/sshfs'

if os[:family] == 'windows'
  puts 'Not implemented on Windows'
  broken = true
elsif os[:family] == 'RedHat'
  docker_args = "repo_opt => '--enablerepo=localmirror-extras'"
elsif os[:name] == 'Ubuntu' && os[:release][:full] == '14.04'
  docker_args = "version => '18.06.1~ce~3-0~ubuntu'"
else
  docker_args = ''
end

describe 'docker plugin', win_broken: broken do
  before(:all) do
    install_code = "class { 'docker': #{docker_args}}"
    apply_manifest(install_code, catch_failures: true)
  end

  it "#{command} plugin --help" do
    run_shell("#{command} plugin --help", expect_failures: false)
  end

  context 'manage a plugin' do
    after(:all) do
      run_shell("#{command} plugin rm -f #{plugin_name}")
    end

    it 'is idempotent' do
      pp = <<-MANIFEST
        docker::plugin { '#{plugin_name}':}
      MANIFEST
      idempotent_apply(pp)
    end

    it 'has installed a plugin' do
      run_shell("#{command} plugin inspect #{plugin_name}", expect_failures: false)
    end
  end
end
