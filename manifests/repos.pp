# == Class: docker::repos
#
#
class docker::repos {

  ensure_packages($docker::prerequired_packages)
  os = downcase($os[name])

  case $::osfamily {
    'Debian': {
      if ($docker::use_upstream_package_source) {
        if ($docker::docker_cs) {
          $location = $docker::package_cs_source_location
          $key_source = $docker::package_cs_key_source
          $package_key = $docker::package_cs_key
        } elsif ($docker::docker_ee) {
          $location = $docker::package_ee_source_location
          $key_source = $docker::package_ee_key_source
          $package_key = $docker::package_ee_key
        } else {
            if ($docker::docker_ce) {
              $location = "https://download.docker.com/linux/${os}"
              $key_source = "https://download.docker.com/linux/${os}/gpg"
            }
        }
        package {['debian-keyring', 'debian-archive-keyring']:
          ensure => installed,
        }
        apt::source { 'docker':
          location => $location,
          release  => $docker::package_release,
          repos    => $docker::package_repos,
          key      => {
            id     => $package_key,
            source => $key_source,
          },
          require  => Package['debian-keyring', 'debian-archive-keyring'],
          include  => { 'src' => false, },
        }
        $url_split = split($location, '/')
        $repo_host = $url_split[2]
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
          if $::operatingsystem == 'Debian' and $::lsbdistcodename == 'wheezy' {
            include apt::backports
          }
          Exec['apt_update'] -> Package[$docker::prerequired_packages]
          Apt::Source['docker'] -> Package['docker']
        }
      }

    }
    'RedHat': {
      $os = downcase($::os[name])

      if ($docker::manage_package) {
        if ($docker::docker_cs) {
          $baseurl = $docker::package_cs_source_location
          $gpgkey = $docker::package_cs_key_source
        }
        elsif ($docker::docker_ee) {
          $baseurl = $docker::package_ee_source_location
          $gpgkey = $docker::package_ee_key_source
        }
        else {
          if ($docker::docker_ce) {
            $package_source_location = "https://download.docker.com/linux/${os}/${::operatingsystemmajrelease}/${::architecture}/${docker::docker_ce_channel}"
            $package_key_source = 'https://download.docker.com/linux/centos/gpg'
          } else {
            $package_source_location = "https://yum.dockerproject.org/repo/main/$os/${::operatingsystemmajrelease}"
            $package_key_source = 'https://yum.dockerproject.org/gpg'
          }

          $baseurl = $package_source_location
          $gpgkey = $package_key_source
        }
        if ($docker::use_upstream_package_source) {
          yumrepo { 'docker':
            descr    => 'Docker',
            baseurl  => $baseurl,
            gpgkey   => $gpgkey,
            gpgcheck => true,
          }
          Yumrepo['docker'] -> Package['docker']
        }
        if ($::operatingsystem != 'Amazon') and ($::operatingsystem != 'Fedora') {
          if ($docker::manage_epel == true) {
            include 'epel'
            Class['epel'] -> Package['docker']
          }
        }
      }
    }
    default: {}
  }
}