#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def service_scale(service, scale, detach)
  cmd = ['docker', 'service', 'scale']
  cmd.concat([" #{service}"]) unless service.nil?
  cmd.concat(["=#{scale}"]) unless scale.nil?
  cmd.concat([' -d']) unless detach.nil?

  stdout, stderr, status = Open3.capture3(cmd)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
service = params['service']
scale = params['scale']
detach = params['detach']

begin
  result = service_scale(service, scale, detach)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
