# @summary manage the docker service daemon
#
# @param tcp_bind
#   Which tcp port, if any, to bind the docker service to.
#
# @param ip_forward
#   This flag interacts with the IP forwarding setting on
#   your host system's kernel
#
# @param iptables
#   Enable Docker's addition of iptables rules
#
# @param ip_masq
#   Enable IP masquerading for bridge's IP range.
#
# @param socket_bind
#   Which local unix socket to bind the docker service to.
#
# @param socket_group
#   Which local unix socket to bind the docker service to.
#
# @param root_dir
#   Specify a non-standard root directory for docker.
#
# @param extra_parameters
#   Plain additional parameters to pass to the docker daemon
#
# @param shell_values
#   Array of shell values to pass into init script config files
#
# @param manage_service
#   Specify whether the service should be managed.
#   Valid values are 'true', 'false'.
#   Defaults to 'true'.
#
# @param docker_command
#
# @param docker_start_command
#
# @param service_name
#
# @param icc
#
# @param bridge
#
# @param fixed_cidr
#
# @param default_gateway
#
# @param ipv6
#
# @param ipv6_cidr
#
# @param default_gateway_ipv6
#
# @param log_level
#
# @param log_driver
#
# @param log_opt
#
# @param selinux_enabled
#
# @param labels
#
# @param dns
#
# @param dns_search
#
# @param service_state
#
# @param service_enable
#
# @param proxy
#
# @param no_proxy
#
# @param execdriver
#
# @param bip
#
# @param mtu
#
# @param storage_driver
#
# @param dm_basesize
#
# @param dm_fs
#
# @param dm_mkfsarg
#
# @param dm_mountopt
#
# @param dm_blocksize
#
# @param dm_loopdatasize
#
# @param dm_loopmetadatasize
#
# @param dm_datadev
#
# @param dm_metadatadev
#
# @param tmp_dir_config
#
# @param tmp_dir
#
# @param dm_thinpooldev
#
# @param dm_use_deferred_removal
#
# @param dm_use_deferred_deletion
#
# @param dm_blkdiscard
#
# @param dm_override_udev_sync_check
#
# @param overlay2_override_kernel_check
#
# @param storage_devs
#
# @param storage_vg
#
# @param storage_root_size
#
# @param storage_data_size
#
# @param storage_min_data_size
#
# @param storage_chunk_size
#
# @param storage_growpart
#
# @param storage_auto_extend_pool
#
# @param storage_pool_autoextend_threshold
#
# @param storage_pool_autoextend_percent
#
# @param storage_config
#
# @param storage_config_template
#
# @param storage_setup_file
#
# @param service_provider
#
# @param service_config
#
# @param service_config_template
#
# @param service_overrides_template
#
# @param socket_overrides_template
#
# @param socket_override
#
# @param service_after_override
#
# @param service_hasstatus
#
# @param service_hasrestart
#
# @param daemon_environment_files
#
# @param tls_enable
#
# @param tls_verify
#
# @param tls_cacert
#
# @param tls_cert
#
# @param tls_key
#
# @param registry_mirror
#
# @param root_dir_flag
#
class docker::service (
  String                                  $docker_command                    = $docker::docker_command,
  String                                  $docker_start_command              = $docker::docker_start_command,
  Optional[String]                        $service_name                      = $docker::service_name,
  Optional[Variant[String,Array[String]]] $tcp_bind                          = $docker::tcp_bind,
  Boolean                                 $ip_forward                        = $docker::ip_forward,
  Boolean                                 $iptables                          = $docker::iptables,
  Boolean                                 $ip_masq                           = $docker::ip_masq,
  Optional[Boolean]                       $icc                               = $docker::icc,
  Optional[String]                        $bridge                            = $docker::bridge,
  Optional[String]                        $fixed_cidr                        = $docker::fixed_cidr,
  Optional[String]                        $default_gateway                   = $docker::default_gateway,
  Optional[Boolean]                       $ipv6                              = $docker::ipv6,
  Optional[String]                        $ipv6_cidr                         = $docker::ipv6_cidr,
  Optional[String]                        $default_gateway_ipv6              = $docker::default_gateway_ipv6,
  String                                  $socket_bind                       = $docker::socket_bind,
  Optional[String]                        $log_level                         = $docker::log_level,
  Optional[String]                        $log_driver                        = $docker::log_driver,
  Array                                   $log_opt                           = $docker::log_opt,
  Optional[Boolean]                       $selinux_enabled                   = $docker::selinux_enabled,
  Optional[Variant[String,Boolean]]       $socket_group                      = $docker::socket_group,
  Array                                   $labels                            = $docker::labels,
  Optional[Variant[String,Array]]         $dns                               = $docker::dns,
  Optional[Variant[String,Array]]         $dns_search                        = $docker::dns_search,
  String                                  $service_state                     = $docker::service_state,
  Boolean                                 $service_enable                    = $docker::service_enable,
  Boolean                                 $manage_service                    = $docker::manage_service,
  Optional[String]                        $root_dir                          = $docker::root_dir,
  Optional[Variant[String,Array]]         $extra_parameters                  = $docker::extra_parameters,
  Optional[Variant[String,Array]]         $shell_values                      = $docker::shell_values,
  Optional[String]                        $proxy                             = $docker::proxy,
  Optional[String]                        $no_proxy                          = $docker::no_proxy,
  Optional[String]                        $execdriver                        = $docker::execdriver,
  Optional[String]                        $bip                               = $docker::bip,
  Optional[String]                        $mtu                               = $docker::mtu,
  Optional[String]                        $storage_driver                    = $docker::storage_driver,
  Optional[String]                        $dm_basesize                       = $docker::dm_basesize,
  Optional[String]                        $dm_fs                             = $docker::dm_fs,
  Optional[String]                        $dm_mkfsarg                        = $docker::dm_mkfsarg,
  Optional[String]                        $dm_mountopt                       = $docker::dm_mountopt,
  Optional[String]                        $dm_blocksize                      = $docker::dm_blocksize,
  Optional[String]                        $dm_loopdatasize                   = $docker::dm_loopdatasize,
  Optional[String]                        $dm_loopmetadatasize               = $docker::dm_loopmetadatasize,
  Optional[String]                        $dm_datadev                        = $docker::dm_datadev,
  Optional[String]                        $dm_metadatadev                    = $docker::dm_metadatadev,
  Optional[Boolean]                       $tmp_dir_config                    = $docker::tmp_dir_config,
  Optional[String]                        $tmp_dir                           = $docker::tmp_dir,
  Optional[String]                        $dm_thinpooldev                    = $docker::dm_thinpooldev,
  Optional[Boolean]                       $dm_use_deferred_removal           = $docker::dm_use_deferred_removal,
  Optional[Boolean]                       $dm_use_deferred_deletion          = $docker::dm_use_deferred_deletion,
  Optional[Boolean]                       $dm_blkdiscard                     = $docker::dm_blkdiscard,
  Optional[Boolean]                       $dm_override_udev_sync_check       = $docker::dm_override_udev_sync_check,
  Boolean                                 $overlay2_override_kernel_check    = $docker::overlay2_override_kernel_check,
  Optional[String]                        $storage_devs                      = $docker::storage_devs,
  Optional[String]                        $storage_vg                        = $docker::storage_vg,
  Optional[String]                        $storage_root_size                 = $docker::storage_root_size,
  Optional[String]                        $storage_data_size                 = $docker::storage_data_size,
  Optional[String]                        $storage_min_data_size             = $docker::storage_min_data_size,
  Optional[String]                        $storage_chunk_size                = $docker::storage_chunk_size,
  Optional[Boolean]                       $storage_growpart                  = $docker::storage_growpart,
  Optional[String]                        $storage_auto_extend_pool          = $docker::storage_auto_extend_pool,
  Optional[String]                        $storage_pool_autoextend_threshold = $docker::storage_pool_autoextend_threshold,
  Optional[String]                        $storage_pool_autoextend_percent   = $docker::storage_pool_autoextend_percent,
  Optional[Variant[String,Boolean]]       $storage_config                    = $docker::storage_config,
  Optional[String]                        $storage_config_template           = $docker::storage_config_template,
  Optional[String]                        $storage_setup_file                = $docker::storage_setup_file,
  Optional[String]                        $service_provider                  = $docker::service_provider,
  Optional[Variant[String,Boolean]]       $service_config                    = $docker::service_config,
  Optional[String]                        $service_config_template           = $docker::service_config_template,
  Optional[Variant[String,Boolean]]       $service_overrides_template        = $docker::service_overrides_template,
  Optional[Variant[String,Boolean]]       $socket_overrides_template         = $docker::socket_overrides_template,
  Optional[Boolean]                       $socket_override                   = $docker::socket_override,
  Optional[Variant[String,Boolean]]       $service_after_override            = $docker::service_after_override,
  Optional[Boolean]                       $service_hasstatus                 = $docker::service_hasstatus,
  Optional[Boolean]                       $service_hasrestart                = $docker::service_hasrestart,
  Array                                   $daemon_environment_files          = $docker::daemon_environment_files,
  Boolean                                 $tls_enable                        = $docker::tls_enable,
  Boolean                                 $tls_verify                        = $docker::tls_verify,
  Optional[String]                        $tls_cacert                        = $docker::tls_cacert,
  Optional[String]                        $tls_cert                          = $docker::tls_cert,
  Optional[String]                        $tls_key                           = $docker::tls_key,
  Optional[Variant[String,Array]]         $registry_mirror                   = $docker::registry_mirror,
  String                                  $root_dir_flag                     = $docker::root_dir_flag,
) {
  unless $facts['os']['family'] =~ /(Debian|RedHat|windows)/ or $docker::acknowledge_unsupported_os {
    fail('The docker::service class needs a Debian, Redhat or Windows based system.')
  }

  $dns_array              = any2array($dns)
  $dns_search_array       = any2array($dns_search)
  $labels_array           = any2array($labels)
  $extra_parameters_array = any2array($extra_parameters)
  $shell_values_array     = any2array($shell_values)
  $tcp_bind_array         = any2array($tcp_bind)

  if $service_config != undef {
    $_service_config = $service_config
  } else {
    if $facts['os']['family'] == 'Debian' {
      $_service_config = "/etc/default/${service_name}"
    } else {
      $_service_config = undef
    }
  }

  $_manage_service = $manage_service ? {
    true    => Service['docker'],
    default => [],
  }

  $docker_storage_setup_parameters = {
    'storage_driver'                    => $storage_driver,
    'storage_devs'                      => $storage_devs,
    'storage_vg'                        => $storage_vg,
    'storage_root_size'                 => $storage_root_size,
    'storage_data_size'                 => $storage_data_size,
    'storage_min_data_size'             => $storage_min_data_size,
    'storage_chunk_size'                => $storage_chunk_size,
    'storage_growpart'                  => $storage_growpart,
    'storage_auto_extend_pool'          => $storage_auto_extend_pool,
    'storage_pool_autoextend_threshold' => $storage_pool_autoextend_threshold,
    'storage_pool_autoextend_percent'   => $storage_pool_autoextend_percent,
  }

  if $facts['os']['family'] == 'RedHat' {
    file { $storage_setup_file:
      ensure  => file,
      force   => true,
      content => epp('docker/etc/sysconfig/docker-storage-setup.epp', $docker_storage_setup_parameters),
      before  => $_manage_service,
      notify  => $_manage_service,
    }
  }

  if $facts['os']['family'] == 'windows' {
    $dirs = [
      "${facts['docker_program_data_path']}/docker/",
      "${facts['docker_program_data_path']}/docker/config/",
    ]

    $dirs.each |$dir| {
      file { $dir:
        ensure => directory,
      }
    }
  }

  $parameters_service_overrides_template = {
    'service_after_override'   => $service_after_override,
    'docker_start_command'     => $docker_start_command,
    'daemon_environment_files' => $daemon_environment_files,
  }

  case $service_provider {
    'systemd': {
      file { '/etc/systemd/system/docker.service.d':
        ensure => 'directory',
      }

      if $service_overrides_template {
        file { '/etc/systemd/system/docker.service.d/service-overrides.conf':
          ensure  => file,
          content => epp($service_overrides_template, $parameters_service_overrides_template),
          seltype => 'container_unit_file_t',
          notify  => Exec['docker-systemd-reload-before-service'],
          before  => $_manage_service,
        }
      }

      if $socket_override {
        file { '/etc/systemd/system/docker.socket.d':
          ensure => 'directory',
        }

        file { '/etc/systemd/system/docker.socket.d/socket-overrides.conf':
          ensure  => file,
          content => epp($socket_overrides_template, { 'socket_group' => $socket_group }),
          seltype => 'container_unit_file_t',
          notify  => Exec['docker-systemd-reload-before-service'],
          before  => $_manage_service,
        }
      }

      exec { 'docker-systemd-reload-before-service':
        path        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/',],
        command     => 'systemctl daemon-reload > /dev/null',
        notify      => $_manage_service,
        refreshonly => true,
      }
    }
    'upstart': {
      file { '/etc/init.d/docker':
        ensure => 'link',
        target => '/lib/init/upstart-job',
        force  => true,
        notify => $_manage_service,
      }
    }
    default: {}
  }

  #workaround for docker 1.13 on RedHat 7
  if $facts['docker_server_version'] {
    if $facts['os']['family'] == 'RedHat' and $facts['docker_server_version'] =~ /1\.13.+/ {
      $_skip_storage_config = true
    } else {
      $_skip_storage_config = false
    }
  } else {
    $_skip_storage_config = false
  }

  $storage_config_parameters = {
    'storage_driver'                    => $storage_driver,
    'storage_devs'                      => $storage_devs,
    'storage_vg'                        => $storage_vg,
    'storage_root_size'                 => $storage_root_size,
    'storage_data_size'                 => $storage_data_size,
    'storage_min_data_size'             => $storage_min_data_size,
    'storage_chunk_size'                => $storage_chunk_size,
    'storage_growpart'                  => $storage_growpart,
    'storage_auto_extend_pool'          => $storage_auto_extend_pool,
    'storage_pool_autoextend_threshold' => $storage_pool_autoextend_threshold,
    'storage_pool_autoextend_percent'   => $storage_pool_autoextend_percent,
    'dm_basesize'                       => $dm_basesize,
    'dm_fs'                             => $dm_fs,
    'dm_mkfsarg'                        => $dm_mkfsarg,
    'dm_mountopt'                       => $dm_mountopt,
    'dm_blocksize'                      => $dm_blocksize,
    'dm_loopdatasize'                   => $dm_loopdatasize,
    'dm_loopmetadatasize'               => $dm_loopmetadatasize,
    'dm_thinpooldev'                    => $dm_thinpooldev,
    'dm_datadev'                        => $dm_datadev,
    'dm_metadatadev'                    => $dm_metadatadev,
    'dm_use_deferred_removal'           => $dm_use_deferred_removal,
    'dm_use_deferred_deletion'          => $dm_use_deferred_deletion,
    'dm_blkdiscard'                     => $dm_blkdiscard,
    'dm_override_udev_sync_check'       => $dm_override_udev_sync_check,
    'overlay2_override_kernel_check'    => $overlay2_override_kernel_check,
  }

  if $storage_config {
    unless $_skip_storage_config {
      file { $storage_config:
        ensure  => file,
        force   => true, #force rewrite storage configuration 
        content => epp($storage_config_template, $storage_config_parameters),
        notify  => $_manage_service,
      }
    }
  }

  $parameters = {
    'docker_command' => $docker_command,
    'proxy' => $proxy,
    'no_proxy' => $no_proxy,
    'tmp_dir' => $tmp_dir,
    'root_dir' => $root_dir,
    'root_dir_flag' => $root_dir_flag,
    'tcp_bind' => $tcp_bind,
    'tcp_bind_array' => $tcp_bind_array,
    'tls_enable' => $tls_enable,
    'tls_verify' => $tls_verify,
    'tls_cacert' => $tls_cacert,
    'tls_cert' => $tls_cert,
    'tls_key' => $tls_key,
    'socket_bind' => $socket_bind,
    'ip_forward' => $ip_forward,
    'iptables' => $iptables,
    'ip_masq' => $ip_masq,
    'icc' => $icc,
    'fixed_cidr' => $fixed_cidr,
    'bridge' => $bridge,
    'default_gateway' => $default_gateway,
    'log_level' => $log_level,
    'log_driver' => $log_driver,
    'log_opt' => $log_opt,
    'selinux_enabled' => $selinux_enabled,
    'socket_group' => $socket_group,
    'dns' => $dns,
    'dns_array' => $dns_array,
    'dns_search' => $dns_search,
    'dns_search_array' => $dns_search_array,
    'execdriver' => $execdriver,
    'bip' => $bip,
    'mtu' => $mtu,
    'registry_mirror' => $registry_mirror,
    'storage_driver' => $storage_driver,
    'dm_basesize' => $dm_basesize,
    'dm_fs' => $dm_fs,
    'dm_mkfsarg' => $dm_mkfsarg,
    'dm_mountopt' => $dm_mountopt,
    'dm_blocksize' => $dm_blocksize,
    'dm_loopdatasize' => $dm_loopdatasize,
    'dm_loopmetadatasize' => $dm_loopmetadatasize,
    'dm_thinpooldev' => $dm_thinpooldev,
    'dm_datadev' => $dm_datadev,
    'dm_metadatadev' => $dm_metadatadev,
    'dm_use_deferred_removal' => $dm_use_deferred_removal,
    'dm_use_deferred_deletion' => $dm_use_deferred_deletion,
    'dm_blkdiscard' => $dm_blkdiscard,
    'dm_override_udev_sync_check' => $dm_override_udev_sync_check,
    'overlay2_override_kernel_check' => $overlay2_override_kernel_check,
    'labels' => $labels,
    'extra_parameters' => $extra_parameters,
    'extra_parameters_array' => $extra_parameters_array,
    'shell_values' => $shell_values,
    'shell_values_array' => $shell_values_array,
    'labels_array' => $labels_array,
    'ipv6' => $ipv6,
    'ipv6_cidr' => $ipv6_cidr,
    'default_gateway_ipv6' => $default_gateway_ipv6,
    'tmp_dir_config' => $tmp_dir_config,
  }

  if $_service_config {
    file { $_service_config:
      ensure  => file,
      force   => true,
      content => epp($service_config_template, $parameters),
      notify  => $_manage_service,
    }
  }

  if $manage_service {
    if $facts['os']['family'] == 'windows' {
      reboot { 'pending_reboot':
        when    => 'pending',
        onlyif  => 'component_based_servicing',
        timeout => 1,
      }
    }

    if ! defined(Service['docker']) {
      service { 'docker':
        ensure     => $service_state,
        name       => $service_name,
        enable     => $service_enable,
        hasstatus  => $service_hasstatus,
        hasrestart => $service_hasrestart,
        provider   => $service_provider,
      }
    }
  }
}
