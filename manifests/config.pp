# @summary
#
class docker::config {
  if $facts['os']['family'] != 'windows' {
    docker::system_user { $docker::docker_users: }
  } else {
    docker::windows_account { $docker::docker_users: }
  }
}
