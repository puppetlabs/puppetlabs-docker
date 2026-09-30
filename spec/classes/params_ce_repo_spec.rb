# frozen_string_literal: true

require 'spec_helper'

# docker::params builds the Docker CE repo URL for the RedHat family. Docker retired
# linux/rhel/7 but still ships EL7 packages under linux/centos/7, so EL7 has to resolve
# to the centos path while EL8+ stays on rhel.
#
# init_spec.rb feeds docker_ce_source_location / docker_ce_key_source in as class
# parameters, so it never exercises the docker::params defaults. This does -- it declares
# the class without them and asserts what params.pp actually produces.
describe 'docker', type: :class do
  on_supported_os.each do |os, os_facts|
    next unless os_facts[:os]['family'] == 'RedHat'

    major = os_facts[:os]['release']['major']
    arch = os_facts[:os]['architecture']
    expected_path = (major == '7') ? 'centos' : 'rhel'

    context "on #{os} with the default CE repo settings" do
      let(:facts) { os_facts }
      let(:params) { { 'docker_users' => [] } }

      it "points the docker yumrepo at linux/#{expected_path}/#{major}" do
        is_expected.to contain_yumrepo('docker').with(
          'baseurl' => "https://download.docker.com/linux/#{expected_path}/#{major}/#{arch}/stable",
          'gpgkey' => "https://download.docker.com/linux/#{expected_path}/gpg",
        )
      end
    end
  end
end
