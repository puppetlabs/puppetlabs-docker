#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def node_rm(force, node)
  cmd = ['docker', 'node', 'rm']
  cmd.concat([' --force']) unless force.nil?
  cmd.concat([" #{node}"]) unless node.nil?

  stdout, stderr, status = Open3.capture3(cmd)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
force = params['force']
node = params['node']

begin
  result = node_rm(force, node)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
