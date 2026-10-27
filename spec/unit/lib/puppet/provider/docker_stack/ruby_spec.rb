# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:docker_stack).provider(:ruby) do
  let(:resource) do
    Puppet::Type.type(:docker_stack).new(
      name: 'example',
      compose_files: ['/mock/compose.yml'],
      provider: :ruby,
    )
  end

  let(:provider) { resource.provider }

  describe '#exists?' do
    before(:each) do
      allow(Puppet::Util::Platform).to receive(:windows?).and_return(false)
      allow(provider).to receive(:docker).and_return("example_app-example/image:latest\n")
    end

    it 'does not require a compose file version key' do
      allow(YAML).to receive(:safe_load_file).and_return(
        'services' => {
          'app' => { 'image' => 'example/image:latest' },
        },
      )

      expect(provider.exists?).to be true
    end

    it 'still matches services when a legacy version key is present' do
      allow(YAML).to receive(:safe_load_file).and_return(
        'version' => '3.4',
        'services' => {
          'app' => { 'image' => 'example/image:latest' },
        },
      )

      expect(provider.exists?).to be true
    end

    it 'accepts compose specification versions that were previously rejected' do
      allow(YAML).to receive(:safe_load_file).and_return(
        'version' => '3.8',
        'services' => {
          'app' => { 'image' => 'example/image:latest' },
        },
      )

      expect(provider.exists?).to be true
    end
  end
end
