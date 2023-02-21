# @summary
#
# @param instance
#
class docker::run_instance (
  Hash $instance
) {
  create_resources(docker::run, $instance)
}
