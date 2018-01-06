# == Class: docker
#
# Module to install an up-to-date version of Docker from a package repository.
# This module currently works only on Debian, Red Hat
# and Archlinux based distributions.
#
class docker::install (
 $manage_package = $docker::manage_package,
 $prerequired_packages = $docker::prerequired_packages,
){
  ensure_packages($prerequired_packages,
    {
      ensure => 'present',
      before => Package['docker']
    }
  )
}
