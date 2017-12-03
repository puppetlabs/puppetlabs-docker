require 'spec_helper'
require 'json'


describe Facter::Util::Fact, type: :fact do
  before :each do
    Facter.clear
    docker_network_list  = File.read(fixtures('facts', 'docker_network_list'))
    Facter::Util::Resolution.stubs(:exec).with('docker network ls | tail -n +2').returns(docker_network_list)
    docker_network_names = Array.new
    docker_network_list.each_line {|line| docker_network_names.push line.split[1] }
    docker_network_names.each do |network|
      inspect = File.read(fixtures('facts', "docker_network_inspect_#{network}"))
      Facter::Util::Resolution.stubs(:exec).with("docker network inspect #{network}").returns(inspect)
    end
  end
  after { Facter.clear }

  describe 'docker fact with composer network' do
    before :each do
      Facter.fact(:interfaces).stubs(:value).returns('br-c5810f1e3113,docker0,eth0,lo')
    end
    it do
      fact = File.read(fixtures('facts', 'facts_with_compose'))
      fact = JSON.parse(fact.to_json, {:quirks_mode => true})
      facts = eval(fact)
      expect(Facter.fact(:docker).value).to eq(facts)
    end
  end

  describe 'docker fact without composer network' do
    before :each do
      Facter.fact(:interfaces).stubs(:value).returns('br-19a6ebf6f5a5,docker0,eth0,lo')
    end
    it do
      fact = File.read(fixtures('facts', 'facts_without_compose')).chomp
      fact_json = fact.to_json
      facts = JSON.parse(fact_json, {:quirks_mode => true})
      facts = eval(facts)
      expect(Facter.fact(:docker).value).to eq(facts)
    end
  end
end
