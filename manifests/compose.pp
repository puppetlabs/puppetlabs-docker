# @summary install Docker Compose using the recommended curl command.
#
# @param ensure
#   Whether to install or remove Docker Compose
#   Valid values are absent present
#
# @param version
#   The version of Docker Compose to install.
#
class docker::compose (
  Enum[present,absent] $ensure  = present,
  Optional[String]     $version = undef,
) {
  include docker

  if $docker::manage_package {
    include docker::params

    $_version = $version ? {
      undef   => $docker::params::compose_version,
      default => $version,
    }
    if $_version and $ensure != 'absent' {
      $package_ensure = $_version
    } else {
      $package_ensure = $ensure
    }

    case $facts['os']['family'] {
      'Archlinux': {
        if $package_ensure !~ /^(present|installed|latest|absent)$/ {
          fail('Installing a specific Docker Compose version is not supported on Arch Linux; pacman can only install the current package.')
        }
        # Arch Linux packages the compose plugin as 'docker-compose' in its official repositories
        $_package_name = 'docker-compose'
        $_require      = undef
      }
      'Debian': {
        $_package_name = 'docker-compose-plugin'
        $_require = $docker::use_upstream_package_source ? {
          true  => [Apt::Source['docker'], Class['apt::update']],
          false => undef,
        }
      }
      'RedHat': {
        $_package_name = 'docker-compose-plugin'
        $_require = $docker::use_upstream_package_source ? {
          true  => Yumrepo['docker'],
          false => undef,
        }
      }
      'Windows': {
        fail('The docker compose portion of this module is not supported on Windows')
      }
      default: {
        fail('The docker compose portion of this module only works on Arch Linux, Debian or RedHat')
      }
    }
    package { 'docker-compose-plugin':
      ensure  => $package_ensure,
      name    => $_package_name,
      require => $_require,
    }
  }
}
