#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def swarm_init(advertise_addr, autolock, cert_expiry, dispatcher_heartbeat, external_ca, force_new_cluster, listen_addr, max_snapshots, snapshot_interval)
  cmd = ['docker', 'swarm', 'init']
  cmd.concat([" --advertise-addr=#{advertise_addr}"]) unless advertise_addr.nil?
  cmd.concat([' --autolock']) unless autolock.nil?
  cmd.concat([' --cert-expiry']) unless cert_expiry.nil?
  cmd.concat([" --dispatcher-heartbeat=#{dispatcher_heartbeat}"]) unless dispatcher_heartbeat.nil?
  cmd.concat([" --external-ca=#{external_ca}"]) unless external_ca.nil?
  cmd.concat([' --force-new-cluster']) unless force_new_cluster.nil?
  cmd.concat([" --listen-addr=#{listen_addr}"]) unless listen_addr.nil?
  cmd.concat([" --max-snapshots=#{max_snapshots}"]) unless max_snapshots.nil?
  cmd.concat([" --snapshot-interval=#{snapshot_interval}"]) unless snapshot_interval.nil?

  stdout, stderr, status = Open3.capture3(cmd)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
advertise_addr = params['advertise_addr']
autolock = params['autolock']
cert_expiry = params['cert_expiry']
dispatcher_heartbeat = params['dispatcher_heartbeat']
external_ca = params['external_ca']
force_new_cluster = params['force_new_cluster']
listen_addr = params['listen_addr']
max_snapshots = params['max_snapshots']
snapshot_interval = params['snapshot_interval']

begin
  result = swarm_init(advertise_addr, autolock, cert_expiry, dispatcher_heartbeat, external_ca, force_new_cluster, listen_addr, max_snapshots, snapshot_interval)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
