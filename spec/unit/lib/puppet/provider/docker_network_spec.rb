# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:docker_network).provider(:ruby) do
  let(:provider) { resource.provider }
  let(:instance) { provider.class.instances.first }
  let(:resource) do
    Puppet::Type.type(:docker_network).new(
      ensure: :present,
      name: 'test-network',
      driver: 'host',
      subnet: ['192.168.3.0/24', '10.0.0.0/24'],
    )
  end

  before :each do
    # need to reach deep into puppet to unhook the confinement call, so the provider gets properly loaded
    ['docker', '/usr/local/bin/docker'].each do |docker_path|
      allow(Puppet::Confine::Exists).to receive(:which).with(docker_path).and_return('/usr/local/bin/docker')
    end
  end

  describe 'create' do
    it 'creates a docker network' do
      provider.class.expects(:docker).with(['network', 'create', "--driver=#{resource[:driver]}", "--subnet=#{resource[:subnet][0]}", "--subnet=#{resource[:subnet][1]}", resource[:name]])
      expect(provider.create).to be_nil
    end
  end
end
