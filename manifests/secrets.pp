# @summary
#
# @param ensure
#
# @param label
#
# @param secret_name
#
# @param secret_path
#
define docker::secrets (
  Optional[Enum[present,absent]]  $ensure      = 'present',
  Optional[Variant[String,Array]] $label       = [],
  Optional[String]                $secret_name = undef,
  Optional[String]                $secret_path = undef,
) {
  include docker::params

  $docker_command = "${docker::params::docker_command} secret"

  if $ensure == 'present'{
    $docker_secrets_flags = docker_secrets_flags(
      {
        ensure      => $ensure,
        label       => $label,
        secret_name => $secret_name,
        secret_path => $secret_path,
      }
    )

    $exec_secret   = "${docker_command} ${docker_secrets_flags}"
    $unless_secret = "${docker_command} inspect ${secret_name}"

    exec { "${title} docker secret create":
      command => $exec_secret,
      unless  => $unless_secret,
      path    => [ '/bin', '/usr/bin', ],
    }
  }

  if $ensure == 'absent' {
    exec { "${title} docker secret rm":
      command => "${docker_command} rm ${secret_name}",
      onlyif  => "${docker_command} inspect ${secret_name}",
      path    => [ '/bin', '/usr/bin', ],
    }
  }
}
