# @summary install Docker Compose using the recommended curl command.
#
# @param ensure
#   Whether to install or remove Docker Compose
#   Valid values are absent present
#
# @param version
#   The version of Docker Compose to install.
#
# @param install_path
#   The path where to install Docker Compose.
#
# @param symlink_name
#   The name of the symlink created pointing to the actual docker-compose binary
#   This allows use of own docker-compose wrapper scripts for the times it's
#   necessary to set certain things before running the docker-compose binary
#
# @param proxy
#   Proxy to use for downloading Docker Compose.
#
# @param base_url
#   The base url for installation
#   This allows use of a mirror that follows the same layout as the
#   official repository
#
# @param raw_url
#   Override the raw URL for installation
#   The default is to build a URL from baseurl. If rawurl is set, the caller is
#   responsible for ensuring the URL points to the correct version and
#   architecture.
#
# @param curl_ensure
#   Whether or not the curl package is ensured by this module.
#
class docker::compose(
  Optional[Enum[present,absent]] $ensure       = 'present',
  Optional[String]               $version      = $docker::params::compose_version,
  Optional[String]               $install_path = $docker::params::compose_install_path,
  Optional[String]               $symlink_name = $docker::params::compose_symlink_name,
  Optional[String]               $proxy        = undef,
  Optional[String]               $base_url     = $docker::params::compose_base_url,
  Optional[String]               $raw_url      = undef,
  Optional[Boolean]              $curl_ensure  = $docker::params::curl_ensure,
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

  $docker_compose_location           = "${install_path}/${symlink_name}${file_extension}"
  $docker_compose_location_versioned = "${install_path}/docker-compose-${version}${file_extension}"

  if $ensure == 'present' {
    if $raw_url != undef {
      $docker_compose_url = $raw_url
    } else {
      $docker_compose_url = "${base_url}/${version}/docker-compose-${::kernel}-x86_64${file_extension}"
    }

    if $proxy != undef {
      $proxy_opt = "--proxy ${proxy}"
    } else {
      $proxy_opt = ''
    }

    if $facts['os']['family'] == 'windows' {
      $docker_download_command = "if (Invoke-WebRequest ${docker_compose_url} ${proxy_opt} -UseBasicParsing -OutFile \"${docker_compose_location_versioned}\") { exit 0 } else { exit 1}" # lint:ignore:140chars

      exec { "Install Docker Compose ${version}":
        command  => template('docker/windows/download_docker_compose.ps1.erb'),
        provider => powershell,
        creates  => $docker_compose_location_versioned,
      }

      file { $docker_compose_location:
        ensure  => 'link',
        target  => $docker_compose_location_versioned,
        require => Exec["Install Docker Compose ${version}"],
      }
    } else {
      if $curl_ensure {
        ensure_packages(['curl'])
      }

      exec { "Install Docker Compose ${version}":
        path    => '/usr/bin/',
        cwd     => '/tmp',
        command => "curl -s -S -L ${proxy_opt} ${docker_compose_url} -o ${docker_compose_location_versioned}",
        creates => $docker_compose_location_versioned,
        require => Package['curl'],
      }

      file { $docker_compose_location_versioned:
        owner   => $file_owner,
        mode    => '0755',
        require => Exec["Install Docker Compose ${version}"],
      }

      file { $docker_compose_location:
        ensure  => 'link',
        target  => $docker_compose_location_versioned,
        require => File[$docker_compose_location_versioned],
      }
    }
  } else {
    file { $docker_compose_location_versioned:
      ensure => absent,
    }

    file { $docker_compose_location:
      ensure => absent,
    }
  }
}
