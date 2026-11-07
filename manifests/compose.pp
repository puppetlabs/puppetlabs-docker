# @summary Install Docker Compose from the platform package source.
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
        $package_name = 'docker-compose-plugin'
        $_require = $docker::use_upstream_package_source ? {
          true  => [Apt::Source['docker'], Class['apt::update']],
          false => undef,
        }
      }
      'RedHat': {
        $package_name = 'docker-compose-plugin'
        $_require = $docker::use_upstream_package_source ? {
          true  => Yumrepo['docker'],
          false => undef,
        }
      }
      'Suse': {
        $package_name = 'docker-compose'
        $_require = Package['docker']
      }
      'Windows': {
        fail('The docker compose portion of this module is not supported on Windows')
      }
      default: {
        fail('The docker compose portion of this module only works on Debian, RedHat or SUSE')
      }
    }
    package { $package_name:
      ensure  => $package_ensure,
      require => $_require,
    }
  }
}
