# == Class: docker
#
# Module to install an up-to-date version of Docker from a package repository.
# This module works only on Debian Red Hat and Windows based distributions.
#
# === Parameters
# [*version*]
#   The package version to install, used to set the package name.
#
# [*nuget_package_provider_version*]
#   The version of the NuGet Package provider
#   Default: undef
#
# [*docker_msft_provider_version*]
#   The version of the Microsoft Docker Provider Module
#   Default: undef

class docker::install (
  $version                        = $docker::version,
  $nuget_package_provider_version = $docker::nuget_package_provider_version,
  $docker_msft_provider_version   = $docker::docker_msft_provider_version
) {
  $docker_start_command = $docker::docker_start_command
  if $::osfamily {
    assert_type(Pattern[/^(Debian|RedHat|windows)$/], $::osfamily) |$a, $b| {
      fail translate(('This module only works on Debian, RedHat or Windows.'))
    }
  }
  if $docker::version and $docker::ensure != 'absent' {
    $ensure = $docker::version
  } else {
    $ensure = $docker::ensure
  }

  if $docker::manage_package {
    if empty($docker::repo_opt) {
      $docker_hash = {}
    } else {
      $docker_hash = { 'install_options' => $docker::repo_opt }
    }

    if $docker::package_source {
      case $::osfamily {
        'Debian' : {
          $pk_provider = 'dpkg'
        }
        'RedHat' : {
          $pk_provider = 'rpm'
        }
        'windows' : {
          fail translate('Custom package source is currently not implemented on windows.')
        }
        default : {
          $pk_provider = undef
        }
      }
      case $docker::package_source {
        /docker-engine/ : {
          ensure_resource('package', 'docker', merge($docker_hash, {
            ensure   => $ensure,
            provider => $pk_provider,
            source   => $docker::package_source,
            name     => $docker::docker_engine_package_name,
          }))
        }
        /docker-ce/ : {
          ensure_resource('package', 'docker', merge($docker_hash, {
            ensure   => $ensure,
            provider => $pk_provider,
            source   => $docker::package_source,
            name     => $docker::docker_ce_package_name,
          }))
        }
        #TODO: Windows with download URL
        default : {}
      }


    } else {
      if $::osfamily != 'windows' {
        ensure_resource('package', 'docker', merge($docker_hash, {
          ensure => $ensure,
          name   => $docker::docker_package_name,
        }))
      } else {
        $install_script_path = 'C:/Windows/Temp/install_powershell_provider.ps1'
        file{ $install_script_path:
          ensure  => present,
          force   => true,
          content => template('docker/windows/install_powershell_provider.ps1.erb'),
        }
        exec { 'install-docker-package':
          command   => "& ${install_script_path}",
          provider  => powershell,
          logoutput => true,
        }
        exec { 'service-restart-on-failure':
          command => 'cmd /c "SC failure Docker reset= 432000 actions= restart/30000/restart/60000/restart/60000"',
          path    => 'c:/Windows/System32/'
        }
      }
    }
  }
}
