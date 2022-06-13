# @summary
#   Module to configure private docker registries from which to pull Docker images
#
# @param server
#   The hostname and port of the private Docker registry. Ex: dockerreg:5000
#
# @param ensure
#   Whether or not you want to login or logout of a repository
#
# @param username
#   Username for authentication to private Docker registry.
#   auth is not required.
#
# @param password
#   Password for authentication to private Docker registry. Leave undef if
#   auth is not required.
#
# @param pass_hash
#   The hash to be used for receipt. If left as undef, a hash will be generated
#
# @param email
#   Email for registration to private Docker registry. Leave undef if
#   auth is not required.
#
# @param local_user
#   The local user to log in as. Docker will store credentials in this
#   users home directory
#
# @param local_user_home
#   The local user home directory.
#
# @param version
#
define docker::registry (
  Optional[String]      $server          = $title,
  Enum[present,absent]  $ensure          = 'present',
  Optional[String]      $username        = undef,
  Optional[String]      $password        = undef,
  Optional[String]      $pass_hash       = undef,
  Optional[String]      $email           = undef,
  String                $local_user      = 'root',
  Optional[String]      $local_user_home = undef,
  Optional[String]      $version         = $docker::version,
) {
  include docker::params

  $docker_command = $docker::params::docker_command

  if $facts['os']['family'] == 'windows' {
    $exec_environment = [ "PATH=${::docker_program_files_path}/Docker/", ]
    $exec_timeout     = 3000
    $exec_path        = [ "${::docker_program_files_path}/Docker/", ]
    $exec_provider    = 'powershell'
    $password_env     = '$env:password'
    $exec_user        = undef
  } else {
    $exec_environment = []
    $exec_path        = [ '/bin', '/usr/bin', ]
    $exec_timeout     = 0
    $exec_provider    = undef
    $password_env     = "\${password}"
    $exec_user        = $local_user
    if $local_user_home {
      $_local_user_home = $local_user_home
    } else {
      # set sensible default
      $_local_user_home = ($local_user == 'root') ? {
        true    => '/root',
        default => "/home/${local_user}",
      }
    }
  }

  if $ensure == 'present' {
    if $username != undef and $password != undef and $email != undef and $version != undef and $version =~ /1[.][1-9]0?/ {
      $auth_cmd         = "${docker_command} login -u '${username}' -p \"${password_env}\" -e '${email}' ${server}"
      $auth_environment = "password=${password}"
    } elsif $username != undef and $password != undef {
      $auth_cmd         = "${docker_command} login -u '${username}' -p \"${password_env}\" ${server}"
      $auth_environment = "password=${password}"
    } else {
      $auth_cmd         = "${docker_command} login ${server}"
      $auth_environment = ''
    }
  }  else {
    $auth_cmd         = "${docker_command} logout ${server}"
    $auth_environment = ''
  }

  $docker_auth = "${title}${auth_environment}${auth_cmd}${local_user}"

  if $auth_environment != '' {
    $exec_env = concat($exec_environment, $auth_environment, "docker_auth=${docker_auth}")
  } else {
    $exec_env = concat($exec_environment, "docker_auth=${docker_auth}")
  }

  exec { "${title} auth":
    environment => $exec_env,
    command     => $auth_cmd,
    user        => $exec_user,
    path        => $exec_path,
    timeout     => $exec_timeout,
    provider    => $exec_provider,
    creates     => "/${_local_user_home}/.docker/config.json",
  }
}
