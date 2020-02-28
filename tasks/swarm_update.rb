#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

params = JSON.parse(STDIN.read)
image = params['image']
service = params['service']

begin
  puts 'Deprecated: use docker::service_update instead'
  result = service_update(image, service)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
