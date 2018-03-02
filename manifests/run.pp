# == Define: docker:run
#
# A define which manages a running docker container.
#
# == Parameters
#
# [*restart*]
# Sets a restart policy on the docker run.
# Note: If set, puppet will NOT setup an init script to manage, instead
# it will do a raw docker run command using a CID file to track the container
# ID.
#
# If you want a normal named container with an init script and a restart policy
# you must use the extra_parameters feature and pass it in like this:
#
#    extra_parameters => ['--restart=always']
#
# However, if your system is using sytemd this restart policy will be
# ineffective because the ExecStop commands will run which will cause
# docker to stop restarting it.  In this case you should use the
# systemd_restart option to specify the policy you want.
#
# This will allow the docker container to be restarted if it dies, without
# puppet help.
#
# [*service_prefix*]
#   (optional) The name to prefix the startup script with and the Puppet
#   service resource title with.  Default: 'docker-'
#
# [*restart_service*]
#   (optional) Whether or not to restart the service if the the generated init
#   script changes.  Default: true
#
# [*restart_service_on_docker_refresh*]
#   Whether or not to restart the service if the docker service is restarted.
#   Only has effect if the docker_service parameter is set.
#   Default: true
#
# [*manage_service*]
#  (optional) Whether or not to create a puppet Service resource for the init
#  script.  Disabling this may be useful if integrating with existing modules.
#  Default: true
#
# [*docker_service*]
#  (optional) If (and how) the Docker service itself is managed by Puppet
#  true          -> Service['docker']
#  false         -> no Service dependency
#  anything else -> Service[docker_service]
#  Default: false
#
# [*extra_parameters*]
# An array of additional command line arguments to pass to the `docker run`
# command. Useful for adding additional new or experimental options that the
# module does not yet support.
#
# [*systemd_restart*]
# (optional) If the container is to be managed by a systemd unit file set the
# Restart option on the unit file.  Can be any valid value for this systemd
# configuration.  Most commonly used are on-failure or always.
# Default: on-failure
#
define docker::run(
  Optional[Pattern[/^[\S]*$/]] $image,
  Optional[Pattern[/^present$|^absent$/]] $ensure       = 'present',
  Optional[String] $command                             = undef,
  Optional[Pattern[/^[\d]*(b|k|m|g)$/]] $memory_limit   = '0b',
  Variant[String,Array,Undef] $cpuset                   = [],
  Variant[String,Array,Undef] $ports                    = [],
  Variant[String,Array,Undef] $labels                   = [],
  Variant[String,Array,Undef] $expose                   = [],
  Variant[String,Array,Undef] $volumes                  = [],
  Variant[String,Array,Undef] $links                    = [],
  Optional[Boolean] $use_name                           = false,
  Optional[Boolean] $running                            = true,
  Variant[String,Array,Undef] $volumes_from             = [],
  Optional[String] $net                                 = 'bridge',
  Variant[String,Boolean] $username                     = false,
  Variant[String,Boolean] $hostname                     = false,
  Variant[String,Array,Undef] $env                      = [],
  Variant[String,Array,Undef] $env_file                 = [],
  Variant[String,Array,Undef] $dns                      = [],
  Variant[String,Array,Undef] $dns_search               = [],
  Variant[String,Array,Undef] $lxc_conf                 = [],
  Optional[String] $service_prefix                      = 'docker-',
  Optional[Boolean] $restart_service                    = true,
  Optional[Boolean] $restart_service_on_docker_refresh  = true,
  Optional[Boolean] $manage_service                     = true,
  Variant[String,Boolean] $docker_service               = false,
  Optional[Boolean] $disable_network                    = false,
  Optional[Boolean] $privileged                         = false,
  Optional[Boolean] $detach                             = undef,
  Variant[String,Array[String],Undef] $extra_parameters = undef,
  Optional[String] $systemd_restart                     = 'on-failure',
  Variant[String,Hash,Undef] $extra_systemd_parameters  = {},
  Optional[Boolean] $pull_on_start                      = false,
  Variant[String,Array,Undef] $after                    = [],
  Variant[String,Array,Undef] $after_service            = [],
  Variant[String,Array,Undef] $depends                  = [],
  Variant[String,Array,Undef] $depend_services          = [],
  Optional[Boolean] $tty                                = false,
  Variant[String,Array,Undef] $socket_connect           = [],
  Variant[String,Array,Undef] $hostentries              = [],
  Optional[String] $restart                             = undef,
  Variant[String,Boolean] $before_start                 = false,
  Variant[String,Boolean] $before_stop                  = false,
  Optional[Boolean] $remove_container_on_start          = true,
  Optional[Boolean] $remove_container_on_stop           = true,
  Optional[Boolean] $remove_volume_on_start             = false,
  Optional[Boolean] $remove_volume_on_stop              = false,
  Optional[Integer] $stop_wait_time                     = 0,
  Optional[String] $syslog_identifier                   = undef,
  Optional[Boolean] $read_only                          = false,
) {
  include docker
  if ($socket_connect != []) {
    $sockopts = join(any2array($socket_connect), ',')
    $docker_command = "${docker::docker_command} -H ${sockopts}"
  }else {
    $docker_command = $docker::docker_command
  }
  $service_name = $docker::service_name
  $docker_group = $docker::docker_group

  if $restart {
    assert_type(Pattern[/^(no|always|unless-stopped|on-failure)|^on-failure:[\d]+$/], $restart)
  }

  if ($remove_volume_on_start and !$remove_container_on_start) {
    fail translate(("In order to remove the volume on start for ${title} you need to also remove the container"))
  }

  if ($remove_volume_on_stop and !$remove_container_on_stop) {
    fail translate(("In order to remove the volume on stop for ${title} you need to also remove the container"))
  }

  if $use_name {
    notify { "docker use_name warning: ${title}":
      message  => 'The use_name parameter is no-longer required and will be removed in a future release',
      withpath => true,
    }
  }

  if $systemd_restart {
    assert_type(Pattern[/^(no|always|on-success|on-failure|on-abnormal|on-abort|on-watchdog)$/], $systemd_restart)
  }

  if $detach == undef {
    $valid_detach = $docker::params::detach_service_in_init
  } else {
    $valid_detach = $detach
  }

  $extra_parameters_array = any2array($extra_parameters)
  $after_array = any2array($after)
  $depends_array = any2array($depends)
  $depend_services_array = any2array($depend_services)

  $docker_run_flags = docker_run_flags({
    cpuset          => any2array($cpuset),
    detach          => $valid_detach,
    disable_network => $disable_network,
    dns             => any2array($dns),
    dns_search      => any2array($dns_search),
    env             => any2array($env),
    env_file        => any2array($env_file),
    expose          => any2array($expose),
    extra_params    => any2array($extra_parameters),
    hostentries     => any2array($hostentries),
    hostname        => $hostname,
    links           => any2array($links),
    lxc_conf        => any2array($lxc_conf),
    memory_limit    => $memory_limit,
    net             => $net,
    ports           => any2array($ports),
    labels          => any2array($labels),
    privileged      => $privileged,
    socket_connect  => any2array($socket_connect),
    tty             => $tty,
    username        => $username,
    volumes         => any2array($volumes),
    volumes_from    => any2array($volumes_from),
    read_only       => $read_only,
  })

  $sanitised_title = regsubst($title, '[^0-9A-Za-z.\-_]', '-', 'G')
  if empty($depends_array) {
    $sanitised_depends_array = []
  }
  else {
    $sanitised_depends_array = regsubst($depends_array, '[^0-9A-Za-z.\-_]', '-', 'G')
  }

  if empty($after_array) {
    $sanitised_after_array = []
  }
  else {
    $sanitised_after_array = regsubst($after_array, '[^0-9A-Za-z.\-_]', '-', 'G')
  }

  if $restart {

    $cidfile = "/var/run/${service_prefix}${sanitised_title}.cid"

    $run_with_docker_command = [
      "${docker_command} run -d ${docker_run_flags}",
      "--name ${sanitised_title} --cidfile=${cidfile}",
      "--restart=\"${restart}\" ${image} ${command}",
    ]
    exec { "run ${title} with docker":
      command     => join($run_with_docker_command, ' '),
      unless      => "${docker_command} ps --no-trunc -a | grep `cat ${cidfile}`",
      environment => 'HOME=/root',
      path        => ['/bin', '/usr/bin'],
      timeout     => 0
    }
  } else {

    case $docker::params::service_provider {
      'systemd': {
        $initscript = "/etc/systemd/system/${service_prefix}${sanitised_title}.service"
        $init_template = 'docker/etc/systemd/system/docker-run.erb'
        $mode = '0640'
      }
      'upstart': {
        $initscript = "/etc/init.d/${service_prefix}${sanitised_title}"
        $init_template = 'docker/etc/init.d/docker-run.erb'
        $mode = '0750'
      }
      default: {
        fail translate(('Docker needs a Debian or RedHat based system.'))
      }
    }

    if $syslog_identifier {
      $_syslog_identifier = $syslog_identifier
    } else {
      $_syslog_identifier = "${service_prefix}${sanitised_title}"
    }


    if $ensure == 'absent' {
        service { "${service_prefix}${sanitised_title}":
          ensure    => false,
          enable    => false,
          hasstatus => $docker::params::service_hasstatus,
        }

        exec {
          "remove container ${service_prefix}${sanitised_title}":
            command     => "${docker_command} rm -v ${sanitised_title}",
            refreshonly => true,
            onlyif      => "${docker_command} ps --no-trunc -a --format='table {{.Names}}' | grep '^${sanitised_title}$'",
            path        => ['/bin', '/usr/bin'],
            environment => 'HOME=/root',
            timeout     => 0
        }

        file { "/etc/systemd/system/${service_prefix}${sanitised_title}.service":
          ensure => absent,
          path   => "/etc/systemd/system/${service_prefix}${sanitised_title}.service",
        }
    }
    else {
      file { $initscript:
        ensure  => present,
        content => template($init_template),
        owner   => 'root',
        group   => $docker_group,
        mode    => $mode,
      }

      if $manage_service {
        if $running == false {
          service { "${service_prefix}${sanitised_title}":
            ensure    => $running,
            enable    => false,
            hasstatus => $docker::params::service_hasstatus,
            require   => File[$initscript],
          }
        }
        else {
          # Transition help from moving from CID based container detection to
          # Name-based container detection. See #222 for context.
          # This code should be considered temporary until most people have
          # transitioned. - 2015-04-15
          if $initscript == "/etc/init.d/${service_prefix}${sanitised_title}" {
            # This exec sequence will ensure the old-style CID container is stopped
            # before we replace the init script with the new-style.
            $transition_onlyif = [
              "/usr/bin/test -f /var/run/docker-${sanitised_title}.cid &&",
              "/usr/bin/test -f /etc/init.d/${service_prefix}${sanitised_title}",
            ]
            exec { "/bin/sh /etc/init.d/${service_prefix}${sanitised_title} stop":
              onlyif  => join($transition_onlyif, ' '),
              require => [],
            }
            -> file { "/var/run/${service_prefix}${sanitised_title}.cid":
              ensure => absent,
            }
            -> File[$initscript]
          }

          service { "${service_prefix}${sanitised_title}":
            ensure    => $running,
            enable    => true,
            provider  => $docker::params::service_provider,
            hasstatus => $docker::params::service_hasstatus,
            require   => File[$initscript],
          }
        }

        if $docker_service {
          if $docker_service == true {
            Service['docker'] -> Service["${service_prefix}${sanitised_title}"]
            if $restart_service_on_docker_refresh == true {
              Service['docker'] ~> Service["${service_prefix}${sanitised_title}"]
            }
          } else {
            Service[$docker_service] -> Service["${service_prefix}${sanitised_title}"]
            if $restart_service_on_docker_refresh == true {
              Service[$docker_service] ~> Service["${service_prefix}${sanitised_title}"]
            }
          }
        }
      }
      if $docker::params::service_provider == 'systemd' {
        exec { "docker-${sanitised_title}-systemd-reload":
          path        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
          command     => 'systemctl daemon-reload',
          refreshonly => true,
          require     => File[$initscript],
          subscribe   => File[$initscript],
        }
        Exec["docker-${sanitised_title}-systemd-reload"] -> Service<| title == "${service_prefix}${sanitised_title}" |>
      }

      if $restart_service {
        File[$initscript] ~> Service<| title == "${service_prefix}${sanitised_title}" |>
      }
      else {
        File[$initscript] -> Service<| title == "${service_prefix}${sanitised_title}" |>
      }
    }
  }
}
