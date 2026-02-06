# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:docker_compose).provider(:ruby) do
  let(:resource) do
    Puppet::Type.type(:docker_compose).new(
      name: 'test_project',
      compose_files: ['/tmp/docker-compose.yml'],
      provider: :ruby,
    )
  end

  let(:provider) { resource.provider }

  describe '#exists?' do
    before(:each) do
      allow(Puppet::Util::Platform).to receive(:windows?).and_return(false)
      allow(provider).to receive(:execute).and_return(YAML.safe_load("services:\n  web:\n    image: mysql\n    restart: always\n"))
      allow(provider).to receive(:docker).and_return("'db-mysql'\n")
    end

    it 'ignores services with restart: no' do
      # Mock the compose_output to have services with restart: 'no'
      allow(Puppet::Util::Yaml).to receive(:safe_load).and_return({
                                                                    'services' => {
                                                                      'web' => { 'image' => 'nginx', 'restart' => 'no' },
                                                                      'db' => { 'image' => 'mysql', 'restart' => 'always' }
                                                                    }
                                                                  })

      # Only db should be considered, and it matches the running container
      expect(provider.exists?).to be true
    end
  end
end
