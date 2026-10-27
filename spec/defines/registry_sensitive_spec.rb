# frozen_string_literal: true

require 'spec_helper'

describe 'docker::registry', type: :define do
  ubuntu_facts = on_supported_os.find { |os, _| os.start_with?('ubuntu-22') }.last
  windows_os_facts = on_supported_os.find { |os, _| os.start_with?('windows-2022') }.last
  let(:title) { 'example.com' }
  let(:base) { { 'username' => 'u', 'password' => RSpec::Puppet::Sensitive.new('pw'), 'pass_hash' => 'h', 'receipt' => false } }

  context 'on Ubuntu with email and Docker 1.10' do
    let(:facts) { ubuntu_facts }
    let(:pre_condition) { 'class { "docker": }' }
    let(:params) { base.merge('email' => 'a@b.c', 'version' => '1.10') }

    it { is_expected.to compile.and_raise_error(%r{cannot be combined with `email`}) }
  end

  context 'on Ubuntu with receipt => true' do
    let(:facts) { ubuntu_facts }
    let(:pre_condition) { 'class { "docker": }' }
    let(:params) { base.merge('version' => '17.06', 'receipt' => true) }

    it { is_expected.to compile }
    it { is_expected.to contain_file('//root/registry-auth-puppet_receipt_example.com_root').with_content(sensitive('h')) }

    it {
      is_expected.to contain_exec('example.com auth').with(
        'environment' => [],
        'command' => sensitive(%q(printf '%s' 'pw' | docker login -u 'u' --password-stdin example.com || (rm -f "//root/registry-auth-puppet_receipt_example.com_root"; exit 1;))),
      )
    }
  end

  context 'on Windows' do
    let(:facts) { windows_facts.merge('docker_home_dirs' => { 'root' => '/root' }).merge(windows_os_facts) }
    let(:pre_condition) { 'class { "docker": docker_ee => true }' }
    let(:params) { base }

    it { is_expected.to compile.and_raise_error(%r{not supported on Windows}) }
  end
end
