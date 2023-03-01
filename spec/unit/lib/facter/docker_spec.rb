# frozen_string_literal: true

require 'spec_helper'
require 'json'

describe 'Facter::Util::Fact' do
  let(:docker_command) do
    if Facter.value(:kernel) == 'windows'
      'powershell -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -c docker'
    else
      'docker'
    end
  end

  before :each do
    Facter.clear
    allow(Facter::Core::Execution).to receive(:which).and_call_original
    allow(Facter::Core::Execution).to receive(:execute).and_call_original

    if Facter.value(:kernel) == 'windows'
      allow(Facter::Core::Execution).to receive(:which).with('dhcpcd').and_return('C:\Windows\dhcpd.exe')
      allow(Facter::Core::Execution).to receive(:which).with('route').and_return('C:\Windows\System32\ROUTE.EXE')
      allow(Facter::Core::Execution).to receive(:which).with('docker').and_return('C:\Program Files\Docker\docker.exe')
    else
      allow(Facter::Core::Execution).to receive(:which).with('route').and_return('/usr/bin/route')
      allow(Facter::Core::Execution).to receive(:which).with('dhcpcd').and_return('/usr/bin/dhcpd')
      allow(Facter::Core::Execution).to receive(:which).with('docker').and_return('/usr/bin/docker')
    end
    docker_info = File.read(fixtures('facts', 'docker_info'))
    allow(Facter::Core::Execution).to receive(:execute).with("#{docker_command} info --format '{{json .}}'", timeout: 90).and_return(docker_info)
    processors = File.read(fixtures('facts', 'processors'))
    allow(Facter.fact(:processors)).to receive(:value).and_return(JSON.parse(processors))
    docker_version = File.read(fixtures('facts', 'docker_version'))
    allow(Facter::Core::Execution).to receive(:execute).with("#{docker_command} version --format '{{json .}}'", timeout: 90).and_return(docker_version)
    docker_network_list = File.read(fixtures('facts', 'docker_network_list'))
    allow(Facter::Core::Execution).to receive(:execute).with("#{docker_command} network ls | tail -n +2", timeout: 90).and_return(docker_network_list)
    docker_network_names = []
    docker_network_list.each_line { |line| docker_network_names.push line.split[1] }
    docker_network_names.each do |network|
      inspect = File.read(fixtures('facts', "docker_network_inspect_#{network}"))
      allow(Facter::Core::Execution).to receive(:execute).with("#{docker_command} network inspect #{network}", timeout: 90).and_return(inspect)
    end
    docker_worker_token = File.read(fixtures('facts', 'docker_swarm_worker_token'))
    allow(Facter::Core::Execution).to receive(:execute).with("#{docker_command} swarm join-token worker -q", timeout: 90).and_return(docker_worker_token.chomp)
    docker_manager_token = File.read(fixtures('facts', 'docker_swarm_manager_token'))
    allow(Facter::Core::Execution).to receive(:execute).with("#{docker_command} swarm join-token manager -q", timeout: 90).and_return(docker_manager_token.chomp)
  end
  after(:each) { Facter.clear }

  describe 'docker fact with composer network' do
    before :each do
      allow(Facter.fact(:interfaces)).to receive(:value).and_return('br-c5810f1e3113,docker0,eth0,lo')
    end
    it do
      fact = File.read(fixtures('facts', 'facts_with_compose'))
      fact = JSON.parse(fact.to_json, quirks_mode: true)
      facts = eval(fact) # rubocop:disable Security/Eval
      expect(Facter.fact(:docker).value).to include(
        'network' => facts['network'],
      )
    end
  end

  describe 'docker fact without composer network' do
    before :each do
      allow(Facter.fact(:interfaces)).to receive(:value).and_return('br-19a6ebf6f5a5,docker0,eth0,lo')
    end
    it do
      fact = File.read(fixtures('facts', 'facts_without_compose')).chomp
      fact_json = fact.to_json
      facts = JSON.parse(fact_json, quirks_mode: true)
      facts = eval(facts) # rubocop:disable Security/Eval

      expect(Facter.fact(:docker).value).to include(
        'network' => facts['network'],
      )
    end
  end

  describe 'docker client version' do
    before(:each) do
      docker_version = File.read(fixtures('facts', 'docker_version'))
      allow(Facter.fact(:docker_version)).to receive(:value).and_return(JSON.parse(docker_version))
      allow(Facter.fact(:interfaces)).to receive(:value).and_return('br-19a6ebf6f5a5,docker0,eth0,lo')
    end
    it do
      expect(Facter.fact(:docker_client_version).value).to eq(
        '17.03.1-ce-client',
      )
    end
  end

  describe 'docker_client_version fact containment' do
    [
      '0.0.1',
      '0.5.12',
      '1.12.0',
    ].each do |docker_client_version|
      it "Does not generate a nested fact with legacy version #{docker_client_version}" do
        expect(Facter.fact(:docker_client_version)).to receive(:value).and_return(docker_client_version)
        expect(Facter::Core::Execution).not_to receive(:execute).with("#{docker_command} info --format '{{json .}}'", any_args)

        expect(Facter.fact(:docker).value).to be_nil
      end
    end

    [
      '1.13.0',
      '1.14.0',
      '2.0.0',
      '20.10.22',
      '23.0.1',
      '108.42.1',
    ].each do |docker_client_version|
      it "Generates a nested fact with version #{docker_client_version}" do
        expect(Facter.fact(:docker_client_version)).to receive(:value).and_return(docker_client_version)
        expect(Facter::Core::Execution).to receive(:execute).with("#{docker_command} info --format '{{json .}}'", any_args).and_return('{}')

        expect(Facter.fact(:docker).value).not_to be_nil
      end
    end
  end

  describe 'docker server version' do
    before(:each) do
      docker_version = File.read(fixtures('facts', 'docker_version'))
      allow(Facter.fact(:docker_version)).to receive(:value).and_return(JSON.parse(docker_version))
      allow(Facter.fact(:interfaces)).to receive(:value).and_return('br-19a6ebf6f5a5,docker0,eth0,lo')
    end
    it do
      expect(Facter.fact(:docker_server_version).value).to eq(
        '17.03.1-ce-server',
      )
    end
  end

  describe 'docker info' do
    before :each do
      allow(Facter.fact(:interfaces)).to receive(:value).and_return('br-19a6ebf6f5a5,docker0,eth0,lo')
    end
    it 'has valid entries' do
      expect(Facter.fact(:docker).value).to include(
        'Architecture' => 'x86_64',
      )
    end
  end

  describe 'docker swarm worker join-token' do
    before :each do
      allow(Facter.fact(:interfaces)).to receive(:value).and_return('br-19a6ebf6f5a5,docker0,eth0,lo')
    end
    it do
      expect(Facter.fact(:docker_worker_join_token).value).to eq(
        'SWMTKN-1-2m7ekt7511j5kgrc6seyrewpdxv47ksz1sdg7iybzhuug6nmws-0jh0syqeoj3tlr81p165ydfkm',
      )
    end
  end

  describe 'docker swarm manager join-token' do
    before :each do
      allow(Facter.fact(:interfaces)).to receive(:value).and_return('br-19a6ebf6f5a5,docker0,eth0,lo')
    end
    it do
      expect(Facter.fact(:docker_manager_join_token).value).to eq(
        'SWMTKN-1-2m7ekt7511j5kgrc6seyrewpdxv47ksz1sdg7iybzhuug6nmws-8gh1ns1lcavgau8k9p6ou7xj3',
      )
    end
  end

  describe 'docker swarm worker join-token with inactive swarm cluster' do
    before :each do
      docker_info = File.read(fixtures('facts', 'docker_info_swarm_inactive'))
      allow(Facter::Core::Execution).to receive(:execute).with("#{docker_command} info --format '{{json .}}'", timeout: 90).and_return(docker_info)
    end
    it do
      expect(Facter.fact(:docker_worker_join_token).value).to be_nil
    end
  end

  describe 'docker swarm manager join-token with inactive swarm cluster' do
    before :each do
      docker_info = File.read(fixtures('facts', 'docker_info_swarm_inactive'))
      allow(Facter::Core::Execution).to receive(:execute).with("#{docker_command} info --format '{{json .}}'", timeout: 90).and_return(docker_info)
    end

    it do
      expect(Facter.fact(:docker_manager_join_token).value).to be_nil
    end
  end
end
