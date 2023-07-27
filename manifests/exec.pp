# @summary
#   A define which executes a command inside a container.
#
# @param detach
# @param interactive
# @param env
# @param tty
# @param container
# @param command
# @param unless
# @param sanitise_name
# @param refreshonly
# @param onlyif
#
define docker::exec (
  Boolean $detach               = false,
  Boolean $interactive          = false,
  Array   $env                  = [],
  Boolean $tty                  = false,
  Optional[String]  $container  = undef,
  Optional[String]  $command    = undef,
  Optional[String]  $unless     = undef,
  Boolean $sanitise_name        = true,
  Boolean $refreshonly          = false,
  Optional[String]  $onlyif     = undef,
) {
  include docker::params

  $docker_command = $docker::params::docker_command

  if $facts['os']['family'] == 'windows' {
    $exec_environment = "PATH=${facts['docker_program_files_path']}/Docker/"
    $exec_timeout     = 3000
    $exec_path        = ["${facts['docker_program_files_path']}/Docker/",]
    $exec_provider    = 'powershell'
  } else {
    $exec_environment = 'HOME=/root'
    $exec_path        = ['/bin', '/usr/bin',]
    $exec_timeout     = 0
    $exec_provider    = undef
  }

  $docker_exec_flags = docker_exec_flags({
      detach      => $detach,
      interactive => $interactive,
      tty         => $tty,
      env         => any2array($env),
    }
  )

  if $sanitise_name {
    $sanitised_container = regsubst($container, '[^0-9A-Za-z.\-_]', '-', 'G')
  } else {
    $sanitised_container = $container
  }

  $exec = "${docker_command} exec ${docker_exec_flags} ${sanitised_container} ${command}"

  $unless_command = $unless ? {
    undef   => undef,
    ''      => undef,
    default => "${docker_command} exec ${docker_exec_flags} ${sanitised_container} ${$unless}",
  }

  $onlyif_command = $onlyif ? {
    undef     => undef,
    ''        => undef,
    'running' => "${docker_command} ps --no-trunc --format='table {{.Names}}' | grep '^${sanitised_container}$'",
    default   => $onlyif
  }

  exec { $exec:
    environment => $exec_environment,
    onlyif      => $onlyif_command,
    path        => $exec_path,
    refreshonly => $refreshonly,
    timeout     => $exec_timeout,
    provider    => $exec_provider,
    unless      => $unless_command,
  }
}
