# frozen_string_literal: true

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'shared_examples'
require 'rspec-puppet'

require 'spec_helper_local' if File.file?(File.join(File.dirname(__FILE__), 'spec_helper_local.rb'))

include RspecPuppetFacts # rubocop:disable Style/MixinUsage

default_facts = {
  puppetversion: Puppet.version,
  facterversion: Facter.version
}

default_fact_files = [
  File.expand_path(File.join(File.dirname(__FILE__), 'default_facts.yml')),
  File.expand_path(File.join(File.dirname(__FILE__), 'default_module_facts.yml')),
]

default_fact_files.each do |f|
  next unless File.exist?(f) && File.readable?(f) && File.size?(f)

  begin
    default_facts.merge!(YAML.safe_load(File.read(f), [], [], true))
  rescue StandardError => e
    RSpec.configuration.reporter.message "WARNING: Unable to load #{f}: #{e}"
  end
end

RSpec.configure do |c|
  c.mock_with :rspec
  c.default_facts = default_facts
  c.before :each do
    # set to strictest setting for testing
    # by default Puppet runs at warning level
    Puppet.settings[:strict] = :warning
  end
  c.filter_run_excluding(bolt: true) unless ENV['GEM_BOLT']
end

# Ensures that a module is defined
# @param module_name Name of the module
def ensure_module_defined(module_name)
  module_name.split('::').reduce(Object) do |last_module, next_module|
    last_module.const_set(next_module, Module.new) unless last_module.const_defined?(next_module, false)
    last_module.const_get(next_module, false)
  end
end

RSpec::Matchers.define :require_string_for do |property|
  match do |type_class|
    config = { name: 'name' }
    config[property] = 2
    expect {
      type_class.new(config)
    }.to raise_error(Puppet::Error, %r{#{property} should be a String})
  end
  failure_message do |type_class|
    "#{type_class} should require #{property} to be a String"
  end
end

RSpec::Matchers.define :require_hash_for do |property|
  match do |type_class|
    config = { name: 'name' }
    config[property] = 2
    expect {
      type_class.new(config)
    }.to raise_error(Puppet::Error, %r{#{property} should be a Hash})
  end
  failure_message do |type_class|
    "#{type_class} should require #{property} to be a Hash"
  end
end

RSpec::Matchers.define :require_array_for do |property|
  match do |type_class|
    config = { name: 'name' }
    config[property] = 2
    expect {
      type_class.new(config)
    }.to raise_error(Puppet::Error, %r{#{property} should be an Array})
  end
  failure_message do |type_class|
    "#{type_class} should require #{property} to be an Array"
  end
end

at_exit { RSpec::Puppet::Coverage.report! }

# 'spec_overrides' from sync.yml will appear below this line
