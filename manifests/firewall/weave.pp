
class docker::firewall::weave {

  $weave_router_ip = $::weave_router_ip_on_docker_bridge
  $network_weave = $::network_weave

  ### > -A POSTROUTING -j WEAVE
  firewall { '00101 nat table, POSTROUTING chain jumped to WEAVE chain':
    table => 'nat',
    chain => 'POSTROUTING',
    proto => 'all',
    jump  => 'WEAVE',
  }

  ### > -A FORWARD -i weave -o weave -j ACCEPT
  firewall { '00101 permit FORWARDED packets over weave bridge':
    table    => 'filter',
    chain    => 'FORWARD',
    iniface  => 'weave',
    outiface => 'weave',
    proto    => 'all',
    action   => 'accept',
  }

  if is_ip_address( $weave_router_ip ) {

    ### > -A FORWARD -d 172.17.0.2/32 ! -i docker0 -o docker0 -p udp -m udp --dport 6783 -j ACCEPT
    firewall { '06783 accept and forward weave routing udp packets to weave router, when not from docker interface':
      chain       => 'FORWARD',
      action      => 'accept',
      destination => "${weave_router_ip}/32",
      iniface     => '! docker0',
      outiface    => 'docker0',
      proto       => 'udp',
      dport       => '6783',
    }

    ### > -A FORWARD -d 172.17.0.2/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport 6783 -j ACCEPT
    firewall { '06783 accept and forward weave routing tcp packets to weave router, when not from docker interface':
      chain       => 'FORWARD',
      action      => 'accept',
      destination => "${weave_router_ip}/32",
      iniface     => '! docker0',
      outiface    => 'docker0',
      proto       => 'tcp',
      dport       => '6783',
    }

    ### > -A DOCKER ! -i docker0 -p tcp -m tcp --dport 6783 -j DNAT --to-destination 172.17.0.2:6783
    firewall { '00101 nat table, DOCKER chain, weave routing tcp packets jumped to DNAT chain and weave router':
      table   => 'nat',
      chain   => 'DOCKER',
      proto   => 'tcp',
      iniface => '! docker0',
      dport   => '6783',
      jump    => 'DNAT',
      todest  => "${weave_router_ip}:6783",
    }

    ### > -A DOCKER ! -i docker0 -p udp -m udp --dport 6783 -j DNAT --to-destination 172.17.0.2:6783
    firewall { '00101 nat table, DOCKER chain, weave routing udp packets jumped to DNAT chain and weave router':
      table   => 'nat',
      chain   => 'DOCKER',
      proto   => 'udp',
      iniface => '! docker0',
      dport   => '6783',
      jump    => 'DNAT',
      todest  => "${weave_router_ip}:6783",
    }

  }

  # notify { "Next we MASQUERADE traffic for $network_weave ": }
  if is_ip_address( $network_weave ) {

    ### > -A WEAVE ! -s 10.0.1.0/24 -o weave -j MASQUERADE
    firewall { '00101 nat table, WEAVE chain, MASQUERADE non-weave bridge packets to weave bridge':
      table    => 'nat',
      chain    => 'WEAVE',
      source   => "! ${network_weave}/24",
      outiface => 'weave',
      proto    => 'all',
      jump     => 'MASQUERADE',
    }

    ### > -A WEAVE -s 10.0.1.0/24 ! -o weave -j MASQUERADE
    firewall { '00101 nat table, WEAVE chain, MASQUERADE weave bridge packets bound beyond weave bridge':
      table    => 'nat',
      chain    => 'WEAVE',
      source   => "${network_weave}/24",
      outiface => '! weave',
      proto    => 'all',
      jump     => 'MASQUERADE',
    }

  }

}

# iptables -F; iptables -F -t nat 
# docker -d & 
# weave launch 10.0.1.0/24 68.168.146.147 68.168.146.149 68.168.146.150
# diff ip4tables.rules.docker ip4tables.rules.docker.weave | grep '\-A' > ip4tables.rules.docker.weave.additional
# generates this:

### > -A FORWARD -d 172.17.0.2/32 ! -i docker0 -o docker0 -p udp -m udp --dport 6783 -j ACCEPT
### > -A FORWARD -d 172.17.0.2/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport 6783 -j ACCEPT
### > -A POSTROUTING -j WEAVE
### > -A DOCKER ! -i docker0 -p tcp -m tcp --dport 6783 -j DNAT --to-destination 172.17.0.2:6783
### > -A DOCKER ! -i docker0 -p udp -m udp --dport 6783 -j DNAT --to-destination 172.17.0.2:6783
### > -A WEAVE ! -s 10.0.1.0/24 -o weave -j MASQUERADE
### > -A WEAVE -s 10.0.1.0/24 ! -o weave -j MASQUERADE

