
#

define docker::firewall::listen_to_peer ( $peer ) {

  # must convert $docker::docker_cluster_peers into an array

  $swarm_port = '4243'
  $rule_id = sprintf('%05d',$swarm_port)

  if $::ipaddress_eth0 == $peer {
    # notify { 'no firewall rules required for self': message => "peer: $peer, eth0: $::ipaddress_eth0" }
  } else {
    firewall { "${rule_id} docker swarm ingress from ${peer}":
      chain  => 'INPUT',
      dport  => $swarm_port,
      proto  => 'all',
      source => $peer,
      action => accept,
    }

    firewall { "${rule_id} docker swarm egress to ${peer}":
      chain       => 'OUTPUT',
      dport       => $swarm_port,
      proto       => 'all',
      destination => $peer,
      action      => accept,
    }
  }

}

