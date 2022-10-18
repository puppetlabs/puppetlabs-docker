#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def swarm_leave(force)
  cmd = ['docker', 'swarm', 'leave']
  cmd.concat([' -f']) if force == 'true'
  stdout, stderr, status = Open3.capture3(cmd)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
force = params['force']
begin
  result = swarm_leave(force)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
