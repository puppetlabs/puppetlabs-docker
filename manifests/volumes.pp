# @summary
#
# @param volumes
#
class docker::volumes (
  Hash $volumes
) {
  create_resources(docker_volume, $volumes)
}
