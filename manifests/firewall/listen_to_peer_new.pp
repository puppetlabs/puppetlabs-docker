
#

define docker::firewall::listen_to_peer_new ( $peer ) {

  # must convert $docker::docker_cluster_peers into an array

  $swarm_port = '4243'
  $rule_id = sprintf('%05d',$swarm_port)

  $peers = hiera( 'docker::firewall::docker_cluster_peers_array', [] )
  $docker_swarm_cluster_management_port = hiera( 'docker::firewall::docker_swarm_cluster_management_port', '2377' )
  $rule_id_cmp = sprintf('%05d',$docker_swarm_cluster_management_port)
  $docker_swarm_node_communication_port = hiera( 'docker::firewall::docker_swarm_node_communication_port', '7946' )
  $rule_id_ncp = sprintf('%05d',$docker_swarm_node_communication_port)
  $docker_swarm_overlay_network_port = hiera( 'docker::firewall::docker_swarm_overlay_network_port', '4789' )
  $rule_id_onp = sprintf('%05d',$docker_swarm_overlay_network_port)

  if $::ipaddress_eth0 == $peer {
    # notify { 'no firewall rules required for self': message => "peer: $peer, eth0: $::ipaddress_eth0" }
  } else {
    firewall { "${rule_id} docker swarm ingress tcp from ${peer}":
      chain  => 'INPUT',
      dport  => $swarm_port,
      proto  => tcp,
      source => $peer,
      action => accept,
    }

    firewall { "${rule_id} docker swarm ingress udp from ${peer}":
      chain  => 'INPUT',
      dport  => $swarm_port,
      proto  => udp,
      source => $peer,
      action => accept,
    }

    firewall { "${rule_id} docker swarm egress tcp to ${peer}":
      chain       => 'OUTPUT',
      dport       => $swarm_port,
      proto       => tcp,
      destination => $peer,
      action      => accept,
    }

    firewall { "${rule_id} docker swarm egress udp to ${peer}":
      chain       => 'OUTPUT',
      dport       => $swarm_port,
      proto       => udp,
      destination => $peer,
      action      => accept,
    }

    firewall { "${rule_id_cmp} docker swarm ingress from ${peer}":
      chain  => 'INPUT',
      dport  => $docker_swarm_cluster_management_port,
      proto  => 'tcp',
      source => $peer,
      action => accept,
    }

    firewall { "${rule_id_cmp} docker swarm egress to ${peer}":
      chain       => 'OUTPUT',
      dport       => $docker_swarm_cluster_management_port,
      proto       => 'tcp',
      destination => $peer,
      action      => accept,
    }

    firewall { "${rule_id_ncp} docker swarm ingress tcp from ${peer}":
      chain  => 'INPUT',
      dport  => $docker_swarm_node_communication_port,
      proto  => tcp,
      source => $peer,
      action => accept,
    }

    firewall { "${rule_id_ncp} docker swarm ingress udp from ${peer}":
      chain  => 'INPUT',
      dport  => $docker_swarm_node_communication_port,
      proto  => udp,
      source => $peer,
      action => accept,
    }

    firewall { "${rule_id_ncp} docker swarm egress tcp to ${peer}":
      chain       => 'OUTPUT',
      dport       => $docker_swarm_node_communication_port,
      proto       => tcp,
      destination => $peer,
      action      => accept,
    }

    firewall { "${rule_id_ncp} docker swarm egress udp to ${peer}":
      chain       => 'OUTPUT',
      dport       => $docker_swarm_node_communication_port,
      proto       => udp,
      destination => $peer,
      action      => accept,
    }

    firewall { "${rule_id_onp} docker swarm ingress from ${peer}":
      chain  => 'INPUT',
      dport  => $docker_swarm_overlay_network_port,
      proto  => 'udp',
      source => $peer,
      action => accept,
    }

    firewall { "${rule_id_onp} docker swarm egress to ${peer}":
      chain       => 'OUTPUT',
      dport       => $docker_swarm_overlay_network_port,
      proto       => 'udp',
      destination => $peer,
      action      => accept,
    }

  }

}

