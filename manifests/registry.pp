# == Class: docker
#
# Module to configure private docker registries from which to pull Docker images
# If the registry does not require authentication, this module is not required.
#
# === Parameters
# [*server*]
#   The hostname and port of the private Docker registry. Ex: dockerreg:5000
#
# [*ensure*]
#   Whether or not you want to login or logout of a repository
#
# [*username*]
#   Username for authentication to private Docker registry.
#   auth is not required.
#
# [*password*]
#   Password for authentication to private Docker registry. Leave undef if
#   auth is not required.
#
# [*pass_hash*]
#   The hash to be used for receipt. If left as undef, a hash will be generated
#
# [*email*]
#   Email for registration to private Docker registry. Leave undef if
#   auth is not required.
#
# [*local_user*]
#   The local user to log in as. Docker will store credentials in this
#   users home directory
#
# [*receipt*]
#   Required to be true for idempotency
#
define docker::registry(
  $server      = $title,
  $ensure      = 'present',
  $username    = undef,
  $password    = undef,
  $pass_hash   = undef,
  $email       = undef,
  $local_user  = 'root',
  $version     = $docker::version,
  $receipt     = true,
) {
  include docker::params

  validate_re($ensure, '^(present|absent)$')

  $docker_command = $docker::params::docker_command

  if $ensure == 'present' {
    if $username != undef and $password != undef and $email != undef and $version =~ /1[.][1-9]0?/ {
      $auth_cmd = "${docker_command} login -u '${username}' -p \"\${password}\" -e '${email}' ${server}"
      $auth_environment = "password=${password}"
    }
    elsif $username != undef and $password != undef {
      $auth_cmd = "${docker_command} login -u '${username}' -p \"\${password}\" ${server}"
      $auth_environment = "password=${password}"
    }
    else {
      $auth_cmd = "${docker_command} login ${server}"
      $auth_environment = undef
    }
  }
  else {
    $auth_cmd = "${docker_command} logout ${server}"
    $auth_environment = undef
  }

  if $receipt {
    # no - with pw_hash
    $local_user_strip = regsubst($local_user, '-', '', 'G')

    $_pass_hash = $pass_hash ? {
      'Undef'   => pw_hash("${title}${auth_environment}${auth_cmd}${local_user}", 'SHA-512', $local_user_strip),
      default => $pass_hash
    }

    file { "/root/registry-auth-puppet_receipt_${server}_${local_user}":
      ensure  => $ensure,
      content => $_pass_hash,
      notify  => Exec["${title} auth"],
    }
  }

  exec { "${title} auth":
    environment => $auth_environment,
    command     => $auth_cmd,
    user        => $local_user,
    cwd         => '/root',
    path        => ['/bin', '/usr/bin'],
    timeout     => 0,
    refreshonly => $receipt,
  }

}
