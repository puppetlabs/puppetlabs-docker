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
      'Debian': {
        $_require = $docker::use_upstream_package_source ? {
          true  => [Apt::Source['docker'], Class['apt::update']],
          false => undef,
        }
      }
      'RedHat': {
        $_require = $docker::use_upstream_package_source ? {
          true  => Yumrepo['docker'],
          false => undef,
        }
      }
      'Windows': {
        fail('The docker compose portion of this module is not supported on Windows')
      }
      default: {
        fail('The docker compose portion of this module only works on Debian or RedHat')
      }
    }
    package { 'docker-compose-plugin':
      ensure  => $package_ensure,
      require => $_require,
    }
  }
}
