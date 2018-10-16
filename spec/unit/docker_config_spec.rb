require 'spec_helper'

config = Puppet::Type.type(:docker_config)

describe config do
  let :params do
    [
      :name,
      :file,
    ]
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(config.parameters).to be_include(param)
    end
  end
end