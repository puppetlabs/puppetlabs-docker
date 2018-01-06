# == Class: docker::repos
#
#
class docker::repos (
  $package_repository = $docker::package_repository,
  $manage_repos = $docker::manage_repos,
) {

  ensure_packages($prerequired_packages)

  if $manage_repos {
    case $facts['os']['family'] {
      'Debian': {
        include apt
        create_resources('apt::source', $docker_repository)
      }
      'RedHat': {
        create_resources('yumrepo', $docker_repository)
      }
      default: {
        fail('A package repository must be provided if manage_repos=true')
      }
    }
  }

}
