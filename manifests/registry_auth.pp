# @summary
#
# @param registries
#
class docker::registry_auth(
  $registries
) {
  create_resources(docker::registry, $registries)
}
