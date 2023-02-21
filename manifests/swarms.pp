# @summary
#
# @param swarms
#
class docker::swarms (
  Hash $swarms
) {
  create_resources(docker::swarm, $swarms)
}
