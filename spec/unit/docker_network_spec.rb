require 'spec_helper'

network = Puppet::Type.type(:docker_network)

describe network do

  let :params do
    [
      :name,
      :provider,
      :subnet,
      :gateway,
      :ip_range,
      :aux_address,
      :options,
    ]
  end

  let :properties do
    [
      :ensure,
      :driver,
      :ipam_driver,
      :id,
    ]
  end

  it 'should have expected properties' do
    properties.each do |property|
      expect(network.properties.map(&:name)).to be_include(property)
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(network.parameters).to be_include(param)
    end
  end
end

describe Puppet::Type.type(:docker_network).provider(:docker_network) do
  let(:provider) { resource.provider }
  let(:instance) { provider.class.instances.first }
  let(:resource) do
    Puppet::Type.type(:docker_network).new(
      ensure: :present,
      name: 'test-network',
      driver: 'host',
      subnet: ['192.168.3.0/24', '10.0.0.0/24']
    )
  end

  before :each do
    Puppet::Util.stubs(:which).with('docker').returns('/usr/local/bin/docker')
  end

  describe 'create' do
    it 'creates a docker network' do
      provider.class.expects(:docker).with(["network", "create", "--driver=#{resource[:driver]}", "--subnet=#{resource[:subnet][0]}", "--subnet=#{resource[:subnet][1]}", resource[:name]])
      expect(provider.create).to be_nil
    end
  end
end