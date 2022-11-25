#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def service_update(image, service, constraint_add, constraint_rm)
  cmd_string = 'docker service update'
  cmd_string += " --image #{image}" unless image.nil?

  if constraint_add.is_a? Array
    constraint_add.each do |param|
      cmd_string += " --constraint-add #{param}"
    end
  end

  if constraint_rm.is_a? Array
    constraint_rm.each do |param|
      cmd_string += " --constraint-rm #{param}"
    end
  end

  cmd_string += " #{service}" unless service.nil?

  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
image = params['image']
service = params['service']
constraint_add = params['constraint_add']
constraint_rm = params['constraint_rm']

begin
  result = service_update(image, service, constraint_add, constraint_rm)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
