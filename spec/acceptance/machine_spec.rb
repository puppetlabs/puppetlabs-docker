# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'docker::machine', win_broken: true do
  context 'with default parameters' do
    pp = <<-EOS
      include docker::machine
    EOS

    it 'applies with no errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'is idempotent' do
      apply_manifest(pp, catch_changes: true)
    end

    it 'machine configurable check of docker-machine-0.16.1' do
      expect(file('/usr/local/bin/docker-machine-0.16.1')).to be_file
      expect(file('/usr/local/bin/docker-machine-0.16.1')).to be_owned_by 'root'
      expect(file('/usr/local/bin/docker-machine-0.16.1')).to be_mode 755
    end

    it 'machine configurable check of docker-machine' do
      expect(file('/usr/local/bin/docker-machine')).to be_linked_to '/usr/local/bin/docker-machine-0.16.1'
      expect(file('/usr/local/bin/docker-machine')).to be_symlink
    end

    it 'is installed and working' do
      run_shell('docker-machine --help', expect_failures: false)
    end
  end

  context 'with url => https://gitlab-docker-machine-downloads.s3.amazonaws.com/v0.16.2-gitlab.3/docker-machine' do
    pp = <<-EOS
      class { 'docker::machine':
        version => '0.16.2-gitlab.3',
        url     => 'https://gitlab-docker-machine-downloads.s3.amazonaws.com/v0.16.2-gitlab.3/docker-machine',
      }
    EOS

    it 'applies with no errors' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'is idempotent' do
      apply_manifest(pp, catch_changes: true)
    end

    it 'machine configurable check of docker-machine-0.16.2-gitlab.3' do
      expect(file('/usr/local/bin/docker-machine-0.16.2-gitlab.3')).to be_file
      expect(file('/usr/local/bin/docker-machine-0.16.2-gitlab.3')).to be_owned_by 'root'
      expect(file('/usr/local/bin/docker-machine-0.16.2-gitlab.3')).to be_mode 755
    end

    it 'machine configurable check of docker-machine' do
      expect(file('/usr/local/bin/docker-machine')).to be_linked_to '/usr/local/bin/docker-machine-0.16.2-gitlab.3'
      expect(file('/usr/local/bin/docker-machine')).to be_symlink
    end

    it 'is installed and working' do
      run_shell('docker-machine --help', expect_failures: false)
    end
  end
end
