#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'
require 'shellwords'

def service_create(image, replicas, expose, env, command, extra_params, service, detach)
  cmd = ['docker', 'service', 'create']
  cmd.concat(extra_params) unless extra_params.nil? || extra_params.empty?

  cmd.concat(['--name', service]) unless service.nil?
  cmd.concat(['--replicas', replicas.to_s]) unless replicas.nil?
  cmd.concat(['--publish', Shellwords.join(expose)]) unless expose.nil?

  if env.is_a? Hash
    env.each do |key, value|
      cmd.concat(['--env', Shellwords.escape("#{key}=#{value}")])
    end
  end

  cmd.append(image) unless image.nil?
  cmd.append('-d') unless !detach || detach.nil?
  cmd.concat(command) unless command.nil? || command.empty?

  stdout, stderr, status = Open3.capture3(*cmd)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
image = params['image']
replicas = params['replicas']
expose = params['expose']
env = params['env']
command = params['command']
extra_params = params['extra_params']
service = params['service']
detach = params['detach']

begin
  result = service_create(image, replicas, expose, env, command, extra_params, service, detach)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
