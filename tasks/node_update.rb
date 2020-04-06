#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def node_update(availability, role, label_add, label_rm, node)
  cmd_string = 'docker node update'
  cmd_string += " --availability #{availability}" unless availability.nil?
  cmd_string += " --role #{role}" unless role.nil?

  if label_add.is_a? Array
    label_add.each do |param|
      cmd_string += " --label-add #{param}"
    end
  end

  if label_rm.is_a? Array
    label_rm.each do |param|
      cmd_string += " --label-rm #{param}"
    end
  end

  cmd_string += " #{node}" unless node.nil?

  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
availability = params['availability']
role = params['role']
label_add = params['label_add']
label_rm = params['label_rm']
node = params['node']

begin
  result = node_update(availability, role, label_add, label_rm, node)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
