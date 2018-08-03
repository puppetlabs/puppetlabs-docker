
# -A FORWARD -d 172.17.0.7/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport 5432 -j ACCEPT
# -A DOCKER ! -i docker0 -p tcp -m tcp --dport 5432 -j DNAT --to-destination 172.17.0.7:5432

# -A FORWARD -d 172.17.0.2/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport 25 -j ACCEPT
# -A DOCKER -d 68.168.146.146/32 ! -i docker0 -p tcp -m tcp --dport 25 -j DNAT --to-destination 172.17.0.2:25

define docker::firewall::dnat_published_port (
  $container_ip,
  $published_port,
  $protocol,
  $public_ip = undef,
) {

  $rule_id = sprintf("%05d",$published_port)

  firewall { "$rule_id FORWARD $published_port for $container_ip":
          chain => 'FORWARD',
          dport => [ $published_port ],
          proto => [ $protocol ],
    destination => $container_ip,
        iniface => '! docker0',
       outiface => 'docker0',
         action => accept,
  }

  if $public_ip {
    firewall { "$rule_id dnat $published_port for $container_ip":
          table => 'nat',
          chain => 'DOCKER',
    destination => $public_ip,
        iniface => '! docker0',
          proto => [ $protocol ],
          dport => [ $published_port ],
         todest => "$container_ip:$published_port",
           jump => 'DNAT',
    }
  } else {
    firewall { "$rule_id dnat $published_port for $container_ip":
        table => 'nat',
        chain => 'DOCKER',
      iniface => '! docker0',
        proto => [ $protocol ],
        dport => [ $published_port ],
       todest => "$container_ip:$published_port",
         jump => 'DNAT',
    }
  }

}

