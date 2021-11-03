# @summary
#
# @param networks
#
class docker::networks (
  Optional[Hash[String, Hash]] $networks = undef,
) {
  if $networks {
    create_resources(docker_network, $networks)
  }
}
