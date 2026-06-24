# frozen_string_literal: true

require 'spec_helper'

volume = Puppet::Type.type(:docker_volume)

describe volume do
  let :params do
    [
      :name,
      :provider,
      :options,
    ]
  end

  let :properties do
    [
      :driver,
      :mountpoint,
    ]
  end

  it 'has expected properties' do
    properties.each do |property|
      expect(volume.properties.map(&:name)).to include(property)
    end
  end

  it 'has expected parameters' do
    params.each do |param|
      expect(volume.parameters).to include(param)
    end
  end
end
