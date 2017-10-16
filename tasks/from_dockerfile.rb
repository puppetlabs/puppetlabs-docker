#!/opt/puppetlabs/puppet/bin/ruby

params = JSON.parse(STDIN.read)
container = params['container_name'] || "puppet-container"
build_options = params['build_options'] || "-t"

`sudo docker build #{build_options container params['dockerfile_path']}`
`sudo docker run #{params['options'] container params['command']}`