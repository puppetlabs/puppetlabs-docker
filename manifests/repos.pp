# @summary
#
# @param location
#
# @param key_source
#
# @param key_check_source
#
# @param architecture
#
# @param keyring
#   Absolute path to a file containing the PGP keyring used to sign this repository. Value is used to set signed-by on the source entry.
#   See https://wiki.debian.org/DebianRepository/UseThirdParty for details.
#
class docker::repos (
  $location         = $docker::package_location,
  $key_source       = $docker::package_key_source,
  $key_check_source = $docker::package_key_check_source,
  $architecture     = $facts['os']['architecture'],
  $keyring          = $docker::keyring,
) {
  ensure_packages($docker::prerequired_packages)

  case $facts['os']['family'] {
    'Debian': {
      $release       = $docker::release
      $package_key   = $docker::package_key
      $package_repos = $docker::package_repos

      if ( $facts['os']['distro']['id'] == 'Debian' and versioncmp($facts['os']['distro']['release']['major'],'10') >= 0 ) or ( $facts['os']['distro']['id'] == 'Ubuntu' and versioncmp($facts['os']['distro']['release']['major'],'22') >= 0 ) { # lint:ignore:140chars
        # fix deprecated apt-key warnings
        file { $keyring:
          ensure  => file,
          content => binary_file("${module_name}/etc/apt/keyrings/docker.gpg"),
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
        }
        $key_options = {
          keyring => $keyring,
        }
        apt::key { 'remove-key-from-trusted.gpg-store':
          ensure => absent,
          id     => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
        }
      }
      else {
        $key_options = {
          key => {
            id     => $package_key,
            source => $key_source,
          },
        }
      }

      if ($docker::use_upstream_package_source) {
        apt::source { 'docker':
          location     => $location,
          architecture => $architecture,
          release      => $release,
          repos        => $package_repos,
          include      => {
            src => false,
          },
          *            => $key_options,
        }

        $url_split  = split($location, '/')
        $repo_host  = $url_split[2]
        $pin_ensure = $docker::pin_upstream_package_source ? {
          true    => 'present',
          default => 'absent',
        }

        apt::pin { 'docker':
          ensure   => $pin_ensure,
          origin   => $repo_host,
          priority => $docker::apt_source_pin_level,
        }

        if $docker::manage_package {
          include apt

          if (versioncmp($facts['facterversion'], '2.4.6') <= 0) {
            if $facts['os']['name'] == 'Debian' and $facts['os']['lsb']['distcodename'] == 'wheezy' {
              include apt::backports
            }
          } else {
            if $facts['os']['name'] == 'Debian' and $facts['os']['distro']['codename'] == 'wheezy' {
              include apt::backports
            }
          }
          Exec['apt_update']    -> Package[$docker::prerequired_packages]
          Apt::Source['docker'] -> Package['docker']
        }
      }
    }
    'RedHat': {
      if ($docker::manage_package) {
        $baseurl      = $location
        $gpgkey       = $key_source
        $gpgkey_check = $key_check_source

        if ($docker::use_upstream_package_source) {
          yumrepo { 'docker':
            descr    => 'Docker',
            baseurl  => $baseurl,
            gpgkey   => $gpgkey,
            gpgcheck => $gpgkey_check,
          }

          Yumrepo['docker'] -> Package['docker']
        }
      }
    }
    default: {}
  }
}
