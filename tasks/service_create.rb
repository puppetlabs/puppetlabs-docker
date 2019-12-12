#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def service_create(image, replicas, expose, env, command, extra_params, service, detach)
  cmd_string = 'docker service create'
  if extra_params.is_a? Array
    extra_params.each do |param|
      cmd_string += " #{param}"
    end
  end
  cmd_string += " --name #{service}" unless service.nil?
  cmd_string += " --replicas #{replicas}" unless replicas.nil?
  cmd_string += " --publish #{expose}" unless expose.nil?
  if env.is_a? Hash
    env.each do |key, value|
      cmd_string += " --env #{key}='#{value}'"
    end
  end

  if command.is_a? Array
    cmd_string += command.join(' ')
  elsif command && command.to_s != 'undef'
    cmd_string += command.to_s
  end

  cmd_string += ' -d' unless detach.nil?
  cmd_string += " #{image}" unless image.nil?

  stdout, stderr, status = Open3.capture3(cmd_string)
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
