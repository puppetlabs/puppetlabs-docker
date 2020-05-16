# @summary define that managers a Docker services
#
# @param ensure
#  This ensures that the service is present or not.
#
# @param image
#  The Docker image to spwan the service from.
#
# @param detach
#  Exit immediately instead of waiting for the service to converge (default true)
#
# @param env
#  Set environment variables
#
# @param label
#  Service labels.
#  This used as metdata to configure constraints etc.
#
# @param publish
#  Publish port(s) as node ports.
#
# @param replicas
#  Number of tasks (containers per service)
#
# @param tty
#  Allocate a pseudo-TTY
#
# @param user
#  Username or UID (format: <name|uid>[:<group|gid>])
#
# @param workdir
#  Working directory inside the container
#
# @param extra_params
#  Allows you to pass any other flag that the Docker service create supports.
#  This must be passed as an array. See docker service create --help for all options
#
# @param update
#  This changes the docker command to
#  docker service update, you must pass a service name with this option
#
# @param scale
#  This changes the docker command to
#  docker service scale, this can only be used with service name and
#  replicas
#
# @param host_socket
#  This will allow the service to connect to the host linux socket.
#
# @param registry_mirror
#  This will allow the service to set a registry mirror.
#
# @param mounts
#  Allows attaching filesystem mounts to the service (specified as an array)
#
# @param networks
#  Allows attaching the service to networks (specified as an array)
#
# @param command
#  Command to run on the container
#
# @param create
#
# @param service_name
#
define docker::services(
  Optional[Enum[present,absent]]  $ensure          = 'present',
  Optional[Boolean]               $create          = true,
  Optional[Boolean]               $update          = false,
  Optional[Boolean]               $scale           = false,
  Optional[Boolean]               $detach          = true,
  Optional[Boolean]               $tty             = false,
  Optional[Array]                 $env             = [],
  Optional[Array]                 $label           = [],
  Optional[Array]                 $extra_params    = [],
  Optional[Variant[String,Array]] $image           = undef,
  Optional[Variant[String,Array]] $service_name    = undef,
  Optional[Variant[String,Array]] $publish         = undef,
  Optional[Variant[String,Array]] $replicas        = undef,
  Optional[Variant[String,Array]] $user            = undef,
  Optional[Variant[String,Array]] $workdir         = undef,
  Optional[Variant[String,Array]] $host_socket     = undef,
  Optional[Variant[String,Array]] $registry_mirror = undef,
  Optional[Variant[String,Array]] $mounts          = undef,
  Optional[Array]                 $networks        = undef,
  Optional[Variant[String,Array]] $command         = undef,
) {
  include docker::params

  $docker_command = "${docker::params::docker_command} service"

  if $ensure == 'absent' {
    if $update {
      fail(translate('When removing a service you can not update it.'))
    }

    if $scale {
      fail(translate('When removing a service you can not update it.'))
    }
  }

  if $facts['os']['family'] == 'windows' {
    $exec_environment = "PATH=${::docker_program_files_path}/Docker/;${::docker_systemroot}/System32/"
    $exec_path        = [ "${::docker_program_files_path}/Docker/", ]
    $exec_provider    = 'powershell'
    $exec_timeout     = 3000
  } else {
    $exec_environment = 'HOME=/root'
    $exec_path        = [ '/bin', '/usr/bin', ]
    $exec_provider    = undef
    $exec_timeout     = 0
  }

  if $create {
    $docker_service_create_flags = docker_service_flags(
      {
        detach          => $detach,
        env             => any2array($env),
        service_name    => $service_name,
        label           => any2array($label),
        publish         => $publish,
        replicas        => $replicas,
        tty             => $tty,
        user            => $user,
        workdir         => $workdir,
        extra_params    => any2array($extra_params),
        image           => $image,
        host_socket     => $host_socket,
        registry_mirror => $registry_mirror,
        mounts          => $mounts,
        networks        => $networks,
        command         => $command,
      }
    )

    $exec_create   = "${docker_command} create --name ${docker_service_create_flags}"
    $unless_create = "docker service ps ${service_name}"

    exec { "${title} docker service create":
      command     => $exec_create,
      environment => $exec_environment,
      path        => $exec_path,
      timeout     => $exec_timeout,
      provider    => $exec_provider,
      unless      => $unless_create,
    }
  }

  if $update {
    $docker_service_flags = docker_service_flags(
      {
        detach          => $detach,
        env             => any2array($env),
        service_name    => $service_name,
        label           => any2array($label),
        publish         => $publish,
        replicas        => $replicas,
        tty             => $tty,
        user            => $user,
        workdir         => $workdir,
        extra_params    => any2array($extra_params),
        image           => $image,
        host_socket     => $host_socket,
        registry_mirror => $registry_mirror,
      }
    )

    $exec_update = "${docker_command} update ${docker_service_flags}"

    exec { "${title} docker service update":
      command     => $exec_update,
      environment => $exec_environment,
      path        => $exec_path,
      provider    => $exec_provider,
      timeout     => $exec_timeout,
    }
  }

  if $scale {
    $docker_service_flags = docker_service_flags(
      {
        service_name => $service_name,
        replicas     => $replicas,
        extra_params => any2array($extra_params),
      }
    )

    $exec_scale = "${docker_command} scale ${service_name}=${replicas}"

    exec { "${title} docker service scale":
      command     => $exec_scale,
      environment => $exec_environment,
      path        => $exec_path,
      timeout     => $exec_timeout,
      provider    => $exec_provider,
    }
  }

  if $ensure == 'absent' {
    exec { "${title} docker service remove":
      command  => "docker service rm ${service_name}",
      onlyif   => "docker service ps ${service_name}",
      path     => $exec_path,
      provider => $exec_provider,
      timeout  => $exec_timeout,
    }
  }
}
