# @summary
#
# @param images
#
class docker::images (
  Hash $images
) {
  create_resources(docker::image, $images)
}
