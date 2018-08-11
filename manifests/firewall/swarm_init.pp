
# -A FORWARD -o docker_gwbridge -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# -A FORWARD -o docker_gwbridge -j DOCKER
# -A FORWARD -i docker_gwbridge ! -o docker_gwbridge -j ACCEPT
# -A FORWARD -i docker_gwbridge -o docker_gwbridge -j DROP
# -A DOCKER-ISOLATION-STAGE-1 -i docker_gwbridge ! -o docker_gwbridge -j DOCKER-ISOLATION-STAGE-2
# -A DOCKER-ISOLATION-STAGE-2 -o docker_gwbridge -j DROP
# -A POSTROUTING -s 172.18.0.0/16 ! -o docker_gwbridge -j MASQUERADE
# -A DOCKER -i docker_gwbridge -j RETURN

class docker::firewall::swarm_init {

  # -A FORWARD -o docker_gwbridge -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  firewall { '00131: ACCEPT RELATED, ESTABLISHED bound for docker_gwbridge':
    chain    => 'FORWARD',
    outiface => 'docker_gwbridge',
    ctstate  => [ 'RELATED', 'ESTABLISHED'],
    action   => accept,
  }

  # -A FORWARD -o docker_gwbridge -j DOCKER
  firewall { '00132: outbound to docker_gwbridge jumps to DOCKER chain':
    chain    => 'FORWARD',
    outiface => 'docker_gwbridge',
    jump     => 'DOCKER',
  }

  # -A FORWARD -i docker_gwbridge ! -o docker_gwbridge -j ACCEPT
  firewall { '00133: ACCEPT traffic inbound on docker_gwbridge':
    chain    => 'FORWARD',
    iniface  => 'docker_gwbridge',
    outiface => '! docker_gwbridge',
    action   => accept,
  }

  # -A FORWARD -i docker_gwbridge -o docker_gwbridge -j DROP
  firewall { '00134: DROP traffic inbound and outbound on docker_gwbridge':
    chain    => 'FORWARD',
    iniface  => 'docker_gwbridge',
    outiface => 'docker_gwbridge',
    action   => drop,
  }

  # -A DOCKER-ISOLATION-STAGE-1 -i docker_gwbridge ! -o docker_gwbridge -j DOCKER-ISOLATION-STAGE-2
  firewall { '00135: pass packets through DOCKER-ISOLATION from STAGE-1 to STAGE-2':
    chain    => 'DOCKER-ISOLATION-STAGE-1',
    iniface  => 'docker_gwbridge',
    outiface => '! docker_gwbridge',
    jump     => 'DOCKER-ISOLATION-STAGE-2',
  }

  # -A DOCKER-ISOLATION-STAGE-2 -o docker_gwbridge -j DROP
  firewall { '00136: DROP STAGE-2 packets outbound on docker_gwbridge':
    chain    => 'DOCKER-ISOLATION-STAGE-2',
    outiface => 'docker_gwbridge',
    action   => drop,
  }

  # -A POSTROUTING -s 172.18.0.0/16 ! -o docker_gwbridge -j MASQUERADE
  firewall { '00137: MASQUEARDE docker_gwbridge sourced packets':
    chain    => 'POSTROUTING',
    source   => '172.18.0.0/16',
    outiface => '! docker_gwbridge',
    jump     => 'MASQUERADE',
  }

  # -A DOCKER -i docker_gwbridge -j RETURN
  firewall { '60138: RETURN packets from docker_gwbridge':
    chain    => 'DOCKER',
    iniface  => 'docker_gwbridge',
    jump     => 'RETURN',
  }


}

