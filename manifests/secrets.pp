define docker::secrets (

  Optional[String] $ensure = 'present',
  Variant[String,Array,Undef] $label = [],
  Optional[String] $secret_name = undef,
  Optional[String] $secret_path = undef,
){
  include docker::params

  $docker_command = "${docker::params::docker_command} secret"
  assert_type(Pattern[/^present$|^absent$/], $ensure)
  assert_type(String[1], $docker_command)
  if $secret_name {
  assert_type(String[1], $secret_name)
  }
  if $secret_path {
  assert_type(String[1], $secret_path)
  }
  assert_type(Array, $label)



  if $ensure == 'present'{
  $docker_secrets_flags = docker_secrets_flags ({
    ensure => $ensure,
    label => $label,
    secret_name => $secret_name,
    secret_path => $secret_path,
    })

    $exec_secret = "${docker_command} ${docker_secrets_flags}"
    $unless_secret = "${docker_command} inspect ${secret_name}"

  exec { "${title} docker secret create":
    command => $exec_secret,
    unless  => $unless_secret,
    path    => ['/bin', '/usr/bin'],
    }
  }

  if $ensure == 'absent'{

  exec { "${title} docker secret rm":
    command => "${docker_command} rm ${secret_name}",
    onlyif  => "${docker_command} inspect ${secret_name}",
    path    => ['/bin', '/usr/bin'],
    }
  }
}
