#!/opt/puppetlabs/puppet/bin/ruby

params = JSON.parse(STDIN.read)

`sudo docker run #{params['options'] params['image'] params['command']}`