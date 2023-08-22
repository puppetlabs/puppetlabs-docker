# @summary
#  Module to install an up-to-date version of Docker from a package repository.
#  Only for Debian, Red Hat and Windows
#
# @param version
#   The package version to install, used to set the package name.
#
# @param nuget_package_provider_version
#   The version of the NuGet Package provider
#
# @param docker_msft_provider_version
#   The version of the Microsoft Docker Provider Module
#
# @param docker_ee_package_name
#   The name of the Docker Enterprise Edition package
#
# @param docker_download_url
#
# @param dependent_packages
#
class docker::install (
  Optional[String] $version                        = $docker::version,
  Optional[String] $nuget_package_provider_version = $docker::nuget_package_provider_version,
  Optional[String] $docker_msft_provider_version   = $docker::docker_msft_provider_version,
  Optional[String] $docker_ee_package_name         = $docker::docker_ee_package_name,
  Optional[String] $docker_download_url            = $docker::package_location,
  Array            $dependent_packages             = $docker::dependent_packages,
) {
  $docker_start_command = $docker::docker_start_command

  if $facts['os']['family'] and ! $docker::acknowledge_unsupported_os {
    assert_type(Pattern[/^(Debian|RedHat|windows)$/], $facts['os']['family']) |$a, $b| {
      fail('This module only works on Debian, RedHat or Windows.')
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
      if $facts['os']['family'] == 'windows' {
        fail('Custom package source is currently not implemented on windows.')
      }
      case $docker::package_source {
        /docker-engine/ : {
          ensure_resource('package', 'docker', stdlib::merge($docker_hash, {
                ensure => $ensure,
                source => $docker::package_source,
                name   => $docker::docker_engine_package_name,
          }))
        }
        /docker-ce/ : {
          ensure_resource('package', 'docker', stdlib::merge($docker_hash, {
                ensure => $ensure,
                source => $docker::package_source,
                name   => $docker::docker_ce_package_name,
          }))
          ensure_resource('package', 'docker-ce-cli', stdlib::merge($docker_hash, {
                ensure => $ensure,
                source => $docker::package_source,
                name   => $docker::docker_ce_cli_package_name,
          }))
        }
        default : {
          # Empty
        }
      }
    } else {
      if $facts['os']['family'] != 'windows' {
        ensure_resource('package', 'docker', stdlib::merge($docker_hash, {
              ensure => $ensure,
              name   => $docker::docker_package_name,
        }))

        if $ensure == 'absent' {
          ensure_resource('package', $dependent_packages, {
              ensure => $ensure,
          })
        }
      } else {
        if $ensure == 'absent' {
          $remove_docker_parameters = {
            'docker_ee_package_name' => $docker_ee_package_name,
            'version'                => $version,
          }
          $check_docker_parameters = {
            'docker_ee_package_name' => $docker_ee_package_name,
          }
          exec { 'remove-docker-package':
            command   => epp('docker/windows/remove_docker.ps1.epp', $remove_docker_parameters),
            provider  => powershell,
            unless    => epp('docker/windows/check_docker.ps1.epp', $check_docker_parameters),
            logoutput => true,
          }
        } else {
          if $docker::package_location {
            $download_docker_parameters = {
              'docker_download_url' => $docker_download_url,
            }
            $check_docker_url_parameters = {
              'docker_download_url' => $docker_download_url,
            }
            exec { 'install-docker-package':
              command   => epp('docker/windows/download_docker.ps1.epp', $download_docker_parameters),
              provider  => powershell,
              unless    => epp('docker/windows/check_docker_url.ps1.epp', $check_docker_url_parameters),
              logoutput => true,
              notify    => Exec['service-restart-on-failure'],
            }
          } else {
            $install_powershell_provider_parameters = {
              'nuget_package_provider_version' => $nuget_package_provider_version,
              'docker_msft_provider_version'   => $docker_msft_provider_version,
              'version'                        => $version,
            }

            $check_powershell_provider_parameters = {
              'nuget_package_provider_version' => $nuget_package_provider_version,
              'docker_msft_provider_version'   => $docker_msft_provider_version,
              'docker_ee_package_name'         => $docker_ee_package_name,
              'version'                        => $version,
            }

            exec { 'install-docker-package':
              command   => epp('docker/windows/install_powershell_provider.ps1.epp', $install_powershell_provider_parameters),
              provider  => powershell,
              unless    => epp('docker/windows/check_powershell_provider.ps1.epp', $check_powershell_provider_parameters),
              logoutput => true,
              timeout   => 1800,
              notify    => Exec['service-restart-on-failure'],
            }
          }

          exec { 'service-restart-on-failure':
            command     => 'SC.exe failure Docker reset= 432000 actions= restart/30000/restart/60000/restart/60000',
            refreshonly => true,
            logoutput   => true,
            provider    => powershell,
          }
        }
      }
    }
  }
}
