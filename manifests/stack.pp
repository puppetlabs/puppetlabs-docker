 # == Define: docker::stack
#
# A define that deploys Docker stacks or compose v3
#
# == Paramaters
#
# [*ensure*]
#  This ensures that the stack is present or not.
#  Defaults to present
#
# [*stack_name*]
#   The name of the stack that you are deploying 
#   Defaults to undef
#
# [*bundle_file*]
#  Path to a Distributed Application Bundle file
#  Please note this is experimental
#  Defaults to undef
# 
# [*compose_file*]
#  Path to a Compose file
#  Defaults to undef
#
# [*prune*]
#  Prune services that are no longer referenced
#  Defaults to undef
#
# [*resolve_image*]
#  Query the registry to resolve image digest and supported platforms
#  Only accepts (“always”|“changed”|“never”)
#  Defaults to undef
#
# [*with_registry_auth*]
#  Send registry authentication details to Swarm agents
#  Defaults to undef

define docker::stack(

  $ensure = 'present',
  $stack_name = undef,
  $bundle_file = undef,
  $compose_file = undef,
  $prune = undef,
  $with_registry_auth = undef,

  ){

  include docker::params

  $docker_command = "${docker::params::docker_command} stack"
  validate_re($ensure, '^(present|absent)$')
  validate_string($docker_command)
  validate_string($stack_name)
  validate_string($bundle_file)

  if $ensure == 'present'{
      $docker_stack_flags = docker_stack_flags ({
      stack_name => $stack_name,
      bundle_file => $bundle_file,
      compose_file => $compose_file,
      prune => $prune,
      with_registry_auth => $with_registry_auth,
      })

      $exec_stack = "${docker_command} deploy ${docker_stack_flags} ${stack_name}"
      $unless_stack = "${docker_command} deploy ls | grep ${stack_name}"

      exec { "docker stack create ${stack_name}":
      command => $exec_stack,
      unless  => $unless_stack,
      path    => ['/bin', '/usr/bin'],
    }
  }

  if $ensure == 'absent'{

  exec { "docker stack ${stack_name}":
    command => "${docker_command} rm ${stack_name}",
    onlyif  => "${docker_command} deploy ls | grep ${stack_name}",
    path    => ['/bin', '/usr/bin'],
    }
  }
}
