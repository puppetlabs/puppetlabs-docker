require 'spec_helper_acceptance'

describe 'docker plugin' do
  command = 'docker'

  before(:all) do
    install_code = "class { 'docker': }"
    apply_manifest(install_code, :catch_failures => true)
  end

  describe command("#{command} plugin --help") do
    its(:exit_status) { should eq 0 }
  end

  context 'manage a plugin' do
    before(:all) do
      @name = 'vieux/sshfs'
      @pp = <<-code
        docker::plugin { '#{@name}':}
      code
      apply_manifest(@pp, :catch_failures => true)
    end

    it 'should be idempotent' do
      apply_manifest(@pp, :catch_changes => true)
    end

    it 'should have installed a plugin' do
      shell("#{command} plugin inspect #{@name}", :acceptable_exit_codes => [0])
    end

    after(:all) do
      shell("#{command} plugin rm -f #{@name}")
    end
  end
end
