# @summary
#
# @param plugins
#
class docker::plugins (
  Hash $plugins
) {
  create_resources(docker::plugin, $plugins)
}
