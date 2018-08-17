# docker::networks
class docker::networks($networks) {
  if ( $facts[docker_swarm][swarm][ControlAvailable] == true )
       or ( $facts[docker_swarm][swarm] == 'docker host not running swarm' ) {
    create_resources(docker_network, $networks)
  }
}
