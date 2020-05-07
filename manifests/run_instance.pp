# @summary
#
# @param instance
#
class docker::run_instance(
  $instance
) {
  create_resources(docker::run, $instance)
}
