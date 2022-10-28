#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def swarm_join(advertise_addr, listen_addr, token, manager_ip)
  cmd = ['docker', 'swarm', 'join']
  cmd.concat([" --advertise-addr=#{advertise_addr}"]) unless advertise_addr.nil?
  cmd.concat([" --listen-addr=#{listen_addr}"]) unless listen_addr.nil?
  cmd.concat([" --token=#{token}"]) unless token.nil?
  cmd.concat([" #{manager_ip}"]) unless manager_ip.nil?

  stdout, stderr, status = Open3.capture3(cmd)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
advertise_addr = params['advertise_addr']
listen_addr = params['listen_addr']
token = params['token']
manager_ip = params['manager_ip']

begin
  result = swarm_join(advertise_addr, listen_addr, token, manager_ip)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
