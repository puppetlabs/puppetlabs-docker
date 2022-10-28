#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def node_ls(filter, quiet)
  cmd = ['docker', 'node', 'ls']
  cmd.concat([" --filter=#{filter}"]) unless filter.nil?
  cmd.concat([' --quiet']) unless quiet.nil?

  stdout, stderr, status = Open3.capture3(cmd)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
filter = params['filter']
quiet = params['quiet']

begin
  result = node_ls(filter, quiet)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
