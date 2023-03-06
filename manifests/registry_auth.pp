# @summary
#
# @param registries
#
class docker::registry_auth (
  Hash $registries
) {
  create_resources(docker::registry, $registries)
}
