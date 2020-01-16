require 'spec_helper_acceptance'

describe 'docker::machine' do
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

    describe file('/usr/local/bin/docker-machine-0.16.1') do
      its('owner') { is_expected.to eq 'root' }
      its('mode') { is_expected.to cmp '0755' }
      it { is_expected.to be_file }
    end

    describe file('/usr/local/bin/docker-machine') do
      its('link_path') { is_expected.to eq '/usr/local/bin/docker-machine-0.16.1' }
      it { is_expected.to be_symlink }
    end

    it 'is installed and working' do
      shell('docker-machine --help', acceptable_exit_codes: [0])
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

    describe file('/usr/local/bin/docker-machine-0.16.2-gitlab.3') do
      its('owner') { is_expected.to eq 'root' }
      its('mode') { is_expected.to cmp '0755' }
      it { is_expected.to be_file }
    end

    describe file('/usr/local/bin/docker-machine') do
      its('link_path') { is_expected.to eq '/usr/local/bin/docker-machine-0.16.2-gitlab.3' }
      it { is_expected.to be_symlink }
    end

    it 'is installed and working' do
      shell('docker-machine --help', acceptable_exit_codes: [0])
    end
  end
end
