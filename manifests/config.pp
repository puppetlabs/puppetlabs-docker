# @summary Configuration for docker
# @api private
#
class docker::config {
  if $facts['os']['family'] != 'windows' {
    $docker::docker_users.each |$user| {
      docker::system_user { $user:
        create_user => $docker::create_user,
      }
    }
  } else {
    $docker::docker_users.each |$user| {
      docker::windows_account { $user: }
    }
  }
}
