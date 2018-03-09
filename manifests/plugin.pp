define docker::plugin(
  String $plugin_name                      = $title,
  Optional[Boolean] $enabled               = true,
  Optional[Pattern[/^present$|^absent$/]] $ensure = 'present',
  Optional[String] $timeout                = undef,
  Optional[String] $plugin_alias           = undef,
  Optional[Boolean] $disable_on_install     = false,
  Optional[Boolean] $disable_content_trust  = true,
  Optional[Boolean] $grant_all_permissions = true,
  Optional[String] $install_options        = undef,
  Optional[Boolean] $force_remove          = true,
  Optional[Array] $settings                = [],
  ){

  include docker::params

  $docker_command = "${docker::params::docker_command} plugin"

  if $ensure == 'present' {
    $docker_plugin_install_flags = docker_plugin_install_flags({
      plugin_name => $plugin_name,
      plugin_alias => $plugin_alias,
      disable_on_install => $disable_on_install,
      disable_content_trust => $disable_content_trust,
      grant_all_permissions => $grant_all_permissions,
      settings => $settings,
      })

    $exec_install = "${docker_command} install ${docker_plugin_install_flags}"
    $unless_install = "${docker_command} ls | grep -w ${plugin_name}"

    exec { "plugin install ${plugin_name}":
      command     => $exec_install,
      environment => 'HOME=/root',
      path        => ['/bin', '/usr/bin'],
      timeout     => 0,
      unless      => $unless_install,
      }
  } elsif $ensure == 'absent' {
    $docker_plugin_remove_flags = docker_plugin_remove_flags({
      plugin_name => $plugin_name,
      force_remove => $force_remove,
      })

    $exec_rm = "${docker_command} rm ${docker_plugin_remove_flags}"
    $onlyif_rm = "${docker_command} ls | grep -w ${plugin_name}"

    exec { "plugin remove ${plugin_name}":
      command     => $exec_rm,
      environment => 'HOME=/root',
      path        => ['/bin', '/usr/bin'],
      timeout     => 0,
      onlyif      => $onlyif_rm,
      }
  }

  if $enabled {
    $docker_plugin_enable_flags = docker_plugin_enable_flags({
      plugin_name => $plugin_name,
      timeout => $timeout,
      })

    $exec_enable = "${docker_command} enable ${docker_plugin_enable_flags}"
    $onlyif_enable = "${docker_command} ls -f enabled=false | grep -w ${plugin_name}"

    exec { "plugin enable ${plugin_name}":
      command     => $exec_enable,
      environment => 'HOME=/root',
      path        => ['/bin', '/usr/bin'],
      timeout     => 0,
      onlyif      => $onlyif_enable,
      }

  } elsif $enabled == false {
    exec { "disable ${plugin_name}":
      command     => "${docker_command} disable ${plugin_name}",
      environment => 'HOME=/root',
      path        => ['/bin', '/usr/bin'],
      timeout     => 0,
      unless      => "${docker_command} ls -f enabled=false | grep -w ${plugin_name}",
      }
  }
}
