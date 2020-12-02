# @summary
#  install Docker Machine using the recommended curl command.
#
# @param ensure
#   Whether to install or remove Docker Machine
#   Valid values are absent present
#
# @param version
#   The version of Docker Machine to install.
#
# @param install_path
#   The path where to install Docker Machine.
#
# @param proxy
#   Proxy to use for downloading Docker Machine.
#
# @param url
#   The URL from which the docker machine binary should be fetched
#
# @param curl_ensure
#   Whether or not the curl package is ensured by this module.
#
class docker::machine(
  Optional[Enum[present,absent]]                       $ensure       = 'present',
  Optional[String]                                     $version      = $docker::params::machine_version,
  Optional[String]                                     $install_path = $docker::params::machine_install_path,
  Optional[String]                                     $proxy        = undef,
  Optional[Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl]] $url          = undef,
  Optional[Boolean]                                    $curl_ensure  = $docker::params::curl_ensure,
) inherits docker::params {
  if $proxy != undef {
    validate_re($proxy, '^((http[s]?)?:\/\/)?([^:^@]+:[^:^@]+@|)([\da-z\.-]+)\.([\da-z\.]{2,6})(:[\d])?([\/\w \.-]*)*\/?$')
  }

  if $facts['os']['family'] == 'windows' {
    $file_extension = '.exe'
    $file_owner     = 'Administrator'
  } else {
    $file_extension = ''
    $file_owner     = 'root'
  }

  $docker_machine_location           = "${install_path}/docker-machine${file_extension}"
  $docker_machine_location_versioned = "${install_path}/docker-machine-${version}${file_extension}"

  if $ensure == 'present' {
    $docker_machine_url = $url ? {
      undef   => "https://github.com/docker/machine/releases/download/v${version}/docker-machine-${::kernel}-x86_64${file_extension}",
      default => $url,
    }

    if $proxy != undef {
      $proxy_opt = "--proxy ${proxy}"
    } else {
      $proxy_opt = ''
    }

    if $facts['os']['family'] == 'windows' {
      $docker_download_command = "if (Invoke-WebRequest ${docker_machine_url} ${proxy_opt} -UseBasicParsing -OutFile \"${docker_machine_location_versioned}\") { exit 0 } else { exit 1}" # lint:ignore:140chars

      exec { "Install Docker Machine ${version}":
        command  => template('docker/windows/download_docker_machine.ps1.erb'),
        provider => powershell,
        creates  => $docker_machine_location_versioned,
      }

      file { $docker_machine_location:
        ensure  => 'link',
        target  => $docker_machine_location_versioned,
        require => Exec["Install Docker Machine ${version}"],
      }
    } else {
      if $curl_ensure {
        ensure_packages(['curl'])
      }

      exec { "Install Docker Machine ${version}":
        path    => '/usr/bin/',
        cwd     => '/tmp',
        command => "curl -s -S -L ${proxy_opt} ${docker_machine_url} -o ${docker_machine_location_versioned}",
        creates => $docker_machine_location_versioned,
        require => Package['curl'],
      }

      file { $docker_machine_location_versioned:
        owner   => $file_owner,
        mode    => '0755',
        require => Exec["Install Docker Machine ${version}"],
      }

      file { $docker_machine_location:
        ensure  => 'link',
        target  => $docker_machine_location_versioned,
        require => File[$docker_machine_location_versioned],
      }
    }
  } else {
    file { $docker_machine_location_versioned:
      ensure => absent,
    }

    file { $docker_machine_location:
      ensure => absent,
    }
  }
}
