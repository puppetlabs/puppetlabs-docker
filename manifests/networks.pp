# docker::networks
class docker::networks($networks) {
  if ( $facter[docker_swarm][swarm][ControlAvailable] == true )
       or ( $facter[docker_swarm][swarm] == 'docker host not running swarm' ) {
    create_resources(docker_network, $networks)
  }
}
