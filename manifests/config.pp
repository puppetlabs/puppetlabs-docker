# @summary
#
class docker::config {
  if $facts['os']['family'] != 'windows' {
    $docker::docker_users.each |$user| {
      docker::system_user { $user: }
    }
  } else {
    $docker::docker_users.each |$user| {
      docker::windows_account { $user: }
    }
  }
}
