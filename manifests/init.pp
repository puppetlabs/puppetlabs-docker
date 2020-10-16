# @summary
#   Module to install an up-to-date version of Docker from package.
#
# @param version
#   The package version to install, used to set the package name.
#
# @param ensure
#   Passed to the docker package.
#
# @param prerequired_packages
#   An array of additional packages that need to be installed to support docker.
#
# @param dependent_packages
#  An array of packages installed by the docker-ce package v 18.09 and later.
#  Used when uninstalling to ensure containers cannot be run on the system.
#
# @param tcp_bind
#   The tcp socket to bind to in the format
#   tcp://127.0.0.1:4243
#
# @param tls_enable
#   Enable TLS.
#
# @param tls_verify
#  Use TLS and verify the remote
#
# @param tls_cacert
#   Path to TLS CA certificate
#
# @param tls_cert
#   Path to TLS certificate file
#
# @param tls_key
#   Path to TLS key file
#
# @param ip_forward
#   Enables IP forwarding on the Docker host.
#
# @param iptables
#   Enable Docker's addition of iptables rules.
#
# @param ip_masq
#   Enable IP masquerading for bridge's IP range.
#
# @param icc
#   Enable or disable Docker's unrestricted inter-container and Docker daemon host communication.
#   (Requires iptables=true to disable)
#
# @param bip
#   Specify docker's network bridge IP, in CIDR notation.
#
# @param mtu
#   Docker network MTU.
#
# @param bridge
#   Attach containers to a pre-existing network bridge
#   use 'none' to disable container networking
#
# @param fixed_cidr
#   IPv4 subnet for fixed IPs
#   10.20.0.0/16
#
# @param default_gateway
#   IPv4 address of the container default gateway;
#   this address must be part of the bridge subnet
#   (which is defined by bridge)
#
# @param ipv6
#  Enables ipv6 support for the docker daemon
#
# @param ipv6_cidr
#  IPv6 subnet for fixed IPs
#
# @param default_gateway_ipv6
#  IPv6 address of the container default gateway:
#
# @param socket_bind
#   The unix socket to bind to.
#
# @param log_level
#   Set the logging level
#   Valid values: debug, info, warn, error, fatal
#
# @param log_driver
#   Set the log driver.
#   Docker default is json-file.
#   Valid values: none, json-file, syslog, journald, gelf, fluentd
#   Valid values description:
#     none     : Disables any logging for the container.
#                docker logs won't be available with this driver.
#     json-file: Default logging driver for Docker.
#                Writes JSON messages to file.
#     syslog   : Syslog logging driver for Docker.
#                Writes log messages to syslog.
#     journald : Journald logging driver for Docker.
#                Writes log messages to journald.
#     gelf     : Graylog Extended Log Format (GELF) logging driver for Docker.
#                Writes log messages to a GELF endpoint: Graylog or Logstash.
#     fluentd  : Fluentd logging driver for Docker.
#                Writes log messages to fluentd (forward input).
#     splunk   : Splunk logging driver for Docker.
#                Writes log messages to Splunk (HTTP Event Collector).
#     awslogs  : AWS Cloudwatch Logs logging driver for Docker.
#                Write log messages to Cloudwatch API
#
# @param log_opt
#   Set the log driver specific options
#   Valid values per log driver:
#     none     : undef
#     json-file:
#                max-size=[0-9+][k|m|g]
#                max-file=[0-9+]
#     syslog   :
#                syslog-address=[tcp|udp]://host:port
#                syslog-address=unix://path
#                syslog-facility=daemon|kern|user|mail|auth|
#                                syslog|lpr|news|uucp|cron|
#                                authpriv|ftp|
#                                local0|local1|local2|local3|
#                                local4|local5|local6|local7
#                syslog-tag="some_tag"
#     journald : undef
#     gelf     :
#                gelf-address=udp://host:port
#                gelf-tag="some_tag"
#     fluentd  :
#                fluentd-address=host:port
#                fluentd-tag={{.ID}} - short container id (12 characters)|
#                            {{.FullID}} - full container id
#                            {{.Name}} - container name
#     splunk   :
#                splunk-token=<splunk_http_event_collector_token>
#                splunk-url=https://your_splunk_instance:8088
#     awslogs  :
#                awslogs-group=<Cloudwatch Log Group>
#                awslogs-stream=<Cloudwatch Log Stream>
#                awslogs-create-group=true|false
#                awslogs-datetime-format=<Date format> - strftime expression
#                awslogs-multiline-pattern=multiline start pattern using a regular expression
#                tag={{.ID}} - short container id (12 characters)|
#                    {{.FullID}} - full container id
#                    {{.Name}} - container name
#
# @param selinux_enabled
#   Enable selinux support. Default is false. SELinux does  not  presently
#   support  the  BTRFS storage driver.
#
# @param use_upstream_package_source
#   Whether or not to use the upstream package source.
#   If you run your own package mirror, you may set this
#   to false.
#
# @param pin_upstream_package_source
#   Pin upstream package source; this option currently only has any effect on
#   apt-based distributions.  Set to false to remove pinning on the upstream
#   package repository.  See also "apt_source_pin_level".
#
# @param apt_source_pin_level
#   What level to pin our source package repository to; this only is relevent
#   if you're on an apt-based system (Debian, Ubuntu, etc) and
#   $use_upstream_package_source is set to true.  Set this to false to disable
#   pinning, and undef to ensure the apt preferences file apt::source uses to
#   define pins is removed.
#
# @param service_state
#   Whether you want to docker daemon to start up
#
# @param service_enable
#   Whether you want to docker daemon to start up at boot
#
# @param manage_service
#   Specify whether the service should be managed.
#
# @param root_dir
#   Custom root directory for containers
#
# @param dns
#   Custom dns server address
#
# @param dns_search
#   Custom dns search domains
#
# @param socket_group
#   Group ownership of the unix control socket.
#
# @param extra_parameters
#   Any extra parameters that should be passed to the docker daemon.
#
# @param shell_values
#   Array of shell values to pass into init script config files
#
# @param proxy
#   Will set the http_proxy and https_proxy env variables in /etc/sysconfig/docker (redhat/centos) or /etc/default/docker (debian)
#
# @param no_proxy
#   Will set the no_proxy variable in /etc/sysconfig/docker (redhat/centos) or /etc/default/docker (debian)
#
# @param storage_driver
#   Specify a storage driver to use
#   Valid values: aufs, devicemapper, btrfs, overlay, overlay2, vfs, zfs
#
# @param dm_basesize
#   The size to use when creating the base device, which limits the size of images and containers.
#
# @param dm_fs
#   The filesystem to use for the base image (xfs or ext4)
#
# @param dm_mkfsarg
#   Specifies extra mkfs arguments to be used when creating the base device.
#
# @param dm_mountopt
#   Specifies extra mount options used when mounting the thin devices.
#
# @param dm_blocksize
#   A custom blocksize to use for the thin pool.
#   Default blocksize is 64K.
#   Warning: _DO NOT_ change this parameter after the lvm devices have been initialized.
#
# @param dm_loopdatasize
#   Specifies the size to use when creating the loopback file for the "data" device which is used for the thin pool
#
# @param dm_loopmetadatasize
#   Specifies the size to use when creating the loopback file for the "metadata" device which is used for the thin pool
#
# @param dm_datadev
#   (deprecated - dm_thinpooldev should be used going forward)
#   A custom blockdevice to use for data for the thin pool.
#
# @param dm_metadatadev
#   (deprecated - dm_thinpooldev should be used going forward)
#   A custom blockdevice to use for metadata for the thin pool.
#
# @param dm_thinpooldev
#   Specifies a custom block storage device to use for the thin pool.
#
# @param dm_use_deferred_removal
#   Enables use of deferred device removal if libdm and the kernel driver support the mechanism.
#
# @param dm_use_deferred_deletion
#    Enables use of deferred device deletion if libdm and the kernel driver support the mechanism.
#
# @param dm_blkdiscard
#   Enables or disables the use of blkdiscard when removing devicemapper devices.
#
# @param dm_override_udev_sync_check
#   By default, the devicemapper backend attempts to synchronize with the udev
#   device manager for the Linux kernel. This option allows disabling that
#   synchronization, to continue even though the configuration may be buggy.
#
# @param overlay2_override_kernel_check
#   Overrides the Linux kernel version check allowing using overlay2 with kernel < 4.0.
#
# @param manage_package
#   Won't install or define the docker package, useful if you want to use your own package
#
# @param service_name
#   Specify custom service name
#
# @param docker_users
#   Specify an array of users to add to the docker group
#
# @param docker_group
#   Specify a string for the docker group
#
# @param daemon_environment_files
#   Specify additional environment files to add to the
#   service-overrides.conf
#
# @param repo_opt
#   Specify a string to pass as repository options (RedHat only)
#
# @param storage_devs
#   A quoted, space-separated list of devices to be used.
#
# @param storage_vg
#   The volume group to use for docker storage.
#
# @param storage_root_size
#   The size to which the root filesystem should be grown.
#
# @param storage_data_size
#   The desired size for the docker data LV
#
# @param storage_min_data_size
#   The minimum size of data volume otherwise pool creation fails
#
# @param storage_chunk_size
#   Controls the chunk size/block size of thin pool.
#
# @param storage_growpart
#   Enable resizing partition table backing root volume group.
#
# @param storage_auto_extend_pool
#   Enable/disable automatic pool extension using lvm
#
# @param storage_pool_autoextend_threshold
#   Auto pool extension threshold (in % of pool size)
#
# @param storage_pool_autoextend_percent
#   Extend the pool by specified percentage when threshold is hit.
#
# @param tmp_dir_config
#    Whether to set the TMPDIR value in the systemd config file
#    Default: true (set the value); false will comment out the line.
#    Note: false is backwards compatible prior to PR #58
#
# @param tmp_dir
#    Sets the tmp dir for Docker (path)
#
# @param registry_mirror
#   Sets the prefered container registry mirror.
#
# @param nuget_package_provider_version
#   The version of the NuGet Package provider
#
# @param docker_msft_provider_version
#   The version of the Microsoft Docker Provider Module
#
# @param docker_ce_start_command
# @param docker_ce_package_name
# @param docker_ce_source_location
# @param docker_ce_key_source
# @param docker_ce_key_id
# @param docker_ce_release
# @param docker_package_location
# @param docker_package_key_source
# @param docker_package_key_check_source
# @param docker_package_key_id
# @param docker_package_release
# @param docker_engine_start_command
# @param docker_engine_package_name
# @param docker_ce_channel
# @param docker_ee
# @param docker_ee_package_name
# @param docker_ee_source_location
# @param docker_ee_key_source
# @param docker_ee_key_id
# @param docker_ee_repos
# @param docker_ee_release
# @param package_release
# @param labels
# @param execdriver
# @param package_source
# @param os_lc
# @param storage_config
# @param storage_config_template
# @param storage_setup_file
# @param service_provider
# @param service_config
# @param service_config_template
# @param service_overrides_template
# @param socket_overrides_template
# @param socket_override
# @param service_after_override
# @param service_hasstatus
# @param service_hasrestart
# @param acknowledge_unsupported_os
#
class docker(
  Optional[String]                        $version                           = $docker::params::version,
  String                                  $ensure                            = $docker::params::ensure,
  Variant[Array[String], Hash]            $prerequired_packages              = $docker::params::prerequired_packages,
  Array                                   $dependent_packages                = $docker::params::dependent_packages,
  String                                  $docker_ce_start_command           = $docker::params::docker_ce_start_command,
  Optional[String]                        $docker_ce_package_name            = $docker::params::docker_ce_package_name,
  Optional[String]                        $docker_ce_source_location         = $docker::params::package_ce_source_location,
  Optional[String]                        $docker_ce_key_source              = $docker::params::package_ce_key_source,
  Optional[String]                        $docker_ce_key_id                  = $docker::params::package_ce_key_id,
  Optional[String]                        $docker_ce_release                 = $docker::params::package_ce_release,
  Optional[String]                        $docker_package_location           = $docker::params::package_source_location,
  Optional[String]                        $docker_package_key_source         = $docker::params::package_key_source,
  Optional[Boolean]                       $docker_package_key_check_source   = $docker::params::package_key_check_source,
  Optional[String]                        $docker_package_key_id             = $docker::params::package_key_id,
  Optional[String]                        $docker_package_release            = $docker::params::package_release,
  String                                  $docker_engine_start_command       = $docker::params::docker_engine_start_command,
  String                                  $docker_engine_package_name        = $docker::params::docker_engine_package_name,
  String                                  $docker_ce_channel                 = $docker::params::docker_ce_channel,
  Optional[Boolean]                       $docker_ee                         = $docker::params::docker_ee,
  Optional[String]                        $docker_ee_package_name            = $docker::params::package_ee_package_name,
  Optional[String]                        $docker_ee_source_location         = $docker::params::package_ee_source_location,
  Optional[String]                        $docker_ee_key_source              = $docker::params::package_ee_key_source,
  Optional[String]                        $docker_ee_key_id                  = $docker::params::package_ee_key_id,
  Optional[String]                        $docker_ee_repos                   = $docker::params::package_ee_repos,
  Optional[String]                        $docker_ee_release                 = $docker::params::package_ee_release,
  Optional[Variant[String,Array[String]]] $tcp_bind                          = $docker::params::tcp_bind,
  Boolean                                 $tls_enable                        = $docker::params::tls_enable,
  Boolean                                 $tls_verify                        = $docker::params::tls_verify,
  Optional[String]                        $tls_cacert                        = $docker::params::tls_cacert,
  Optional[String]                        $tls_cert                          = $docker::params::tls_cert,
  Optional[String]                        $tls_key                           = $docker::params::tls_key,
  Boolean                                 $ip_forward                        = $docker::params::ip_forward,
  Boolean                                 $ip_masq                           = $docker::params::ip_masq,
  Optional[Boolean]                       $ipv6                              = $docker::params::ipv6,
  Optional[String]                        $ipv6_cidr                         = $docker::params::ipv6_cidr,
  Optional[String]                        $default_gateway_ipv6              = $docker::params::default_gateway_ipv6,
  Optional[String]                        $bip                               = $docker::params::bip,
  Optional[String]                        $mtu                               = $docker::params::mtu,
  Boolean                                 $iptables                          = $docker::params::iptables,
  Optional[Boolean]                       $icc                               = $docker::params::icc,
  String                                  $socket_bind                       = $docker::params::socket_bind,
  Optional[String]                        $fixed_cidr                        = $docker::params::fixed_cidr,
  Optional[String]                        $bridge                            = $docker::params::bridge,
  Optional[String]                        $default_gateway                   = $docker::params::default_gateway,
  Optional[String]                        $log_level                         = $docker::params::log_level,
  Optional[String]                        $log_driver                        = $docker::params::log_driver,
  Array                                   $log_opt                           = $docker::params::log_opt,
  Optional[Boolean]                       $selinux_enabled                   = $docker::params::selinux_enabled,
  Optional[Boolean]                       $use_upstream_package_source       = $docker::params::use_upstream_package_source,
  Optional[Boolean]                       $pin_upstream_package_source       = $docker::params::pin_upstream_package_source,
  Optional[Integer]                       $apt_source_pin_level              = $docker::params::apt_source_pin_level,
  Optional[String]                        $package_release                   = $docker::params::package_release,
  String                                  $service_state                     = $docker::params::service_state,
  Boolean                                 $service_enable                    = $docker::params::service_enable,
  Boolean                                 $manage_service                    = $docker::params::manage_service,
  Optional[String]                        $root_dir                          = $docker::params::root_dir,
  Optional[Boolean]                       $tmp_dir_config                    = $docker::params::tmp_dir_config,
  Optional[String]                        $tmp_dir                           = $docker::params::tmp_dir,
  Optional[Variant[String,Array]]         $dns                               = $docker::params::dns,
  Optional[Variant[String,Array]]         $dns_search                        = $docker::params::dns_search,
  Optional[Variant[String,Boolean]]       $socket_group                      = $docker::params::socket_group,
  Array                                   $labels                            = $docker::params::labels,
  Optional[Variant[String,Array]]         $extra_parameters                  = undef,
  Optional[Variant[String,Array]]         $shell_values                      = undef,
  Optional[String]                        $proxy                             = $docker::params::proxy,
  Optional[String]                        $no_proxy                          = $docker::params::no_proxy,
  Optional[String]                        $storage_driver                    = $docker::params::storage_driver,
  Optional[String]                        $dm_basesize                       = $docker::params::dm_basesize,
  Optional[String]                        $dm_fs                             = $docker::params::dm_fs,
  Optional[String]                        $dm_mkfsarg                        = $docker::params::dm_mkfsarg,
  Optional[String]                        $dm_mountopt                       = $docker::params::dm_mountopt,
  Optional[String]                        $dm_blocksize                      = $docker::params::dm_blocksize,
  Optional[String]                        $dm_loopdatasize                   = $docker::params::dm_loopdatasize,
  Optional[String]                        $dm_loopmetadatasize               = $docker::params::dm_loopmetadatasize,
  Optional[String]                        $dm_datadev                        = $docker::params::dm_datadev,
  Optional[String]                        $dm_metadatadev                    = $docker::params::dm_metadatadev,
  Optional[String]                        $dm_thinpooldev                    = $docker::params::dm_thinpooldev,
  Optional[Boolean]                       $dm_use_deferred_removal           = $docker::params::dm_use_deferred_removal,
  Optional[Boolean]                       $dm_use_deferred_deletion          = $docker::params::dm_use_deferred_deletion,
  Optional[Boolean]                       $dm_blkdiscard                     = $docker::params::dm_blkdiscard,
  Optional[Boolean]                       $dm_override_udev_sync_check       = $docker::params::dm_override_udev_sync_check,
  Boolean                                 $overlay2_override_kernel_check    = $docker::params::overlay2_override_kernel_check,
  Optional[String]                        $execdriver                        = $docker::params::execdriver,
  Boolean                                 $manage_package                    = $docker::params::manage_package,
  Optional[String]                        $package_source                    = $docker::params::package_source,
  Optional[String]                        $service_name                      = $docker::params::service_name,
  Array                                   $docker_users                      = [],
  String                                  $docker_group                      = $docker::params::docker_group,
  Array                                   $daemon_environment_files          = [],
  Optional[Variant[String,Hash]]          $repo_opt                          = $docker::params::repo_opt,
  Optional[String]                        $os_lc                             = $docker::params::os_lc,
  Optional[String]                        $storage_devs                      = $docker::params::storage_devs,
  Optional[String]                        $storage_vg                        = $docker::params::storage_vg,
  Optional[String]                        $storage_root_size                 = $docker::params::storage_root_size,
  Optional[String]                        $storage_data_size                 = $docker::params::storage_data_size,
  Optional[String]                        $storage_min_data_size             = $docker::params::storage_min_data_size,
  Optional[String]                        $storage_chunk_size                = $docker::params::storage_chunk_size,
  Optional[Boolean]                       $storage_growpart                  = $docker::params::storage_growpart,
  Optional[String]                        $storage_auto_extend_pool          = $docker::params::storage_auto_extend_pool,
  Optional[String]                        $storage_pool_autoextend_threshold = $docker::params::storage_pool_autoextend_threshold,
  Optional[String]                        $storage_pool_autoextend_percent   = $docker::params::storage_pool_autoextend_percent,
  Optional[Variant[String,Boolean]]       $storage_config                    = $docker::params::storage_config,
  Optional[String]                        $storage_config_template           = $docker::params::storage_config_template,
  Optional[String]                        $storage_setup_file                = $docker::params::storage_setup_file,
  Optional[String]                        $service_provider                  = $docker::params::service_provider,
  Optional[Variant[String,Boolean]]       $service_config                    = $docker::params::service_config,
  Optional[String]                        $service_config_template           = $docker::params::service_config_template,
  Optional[Variant[String,Boolean]]       $service_overrides_template        = $docker::params::service_overrides_template,
  Optional[Variant[String,Boolean]]       $socket_overrides_template         = $docker::params::socket_overrides_template,
  Optional[Boolean]                       $socket_override                   = $docker::params::socket_override,
  Optional[Variant[String,Boolean]]       $service_after_override            = $docker::params::service_after_override,
  Optional[Boolean]                       $service_hasstatus                 = $docker::params::service_hasstatus,
  Optional[Boolean]                       $service_hasrestart                = $docker::params::service_hasrestart,
  Optional[Variant[String,Array]]         $registry_mirror                   = $docker::params::registry_mirror,
  Boolean                                 $acknowledge_unsupported_os        = false,

  # Windows specific parameters
  Optional[String]                        $docker_msft_provider_version      = $docker::params::docker_msft_provider_version,
  Optional[String]                        $nuget_package_provider_version    = $docker::params::nuget_package_provider_version,
) inherits docker::params {
  if $facts['os']['family'] and ! $acknowledge_unsupported_os {
    assert_type(Pattern[/^(Debian|RedHat|windows)$/], $facts['os']['family']) |$a, $b| {
      fail(translate('This module only works on Debian, Red Hat or Windows based systems.'))
    }
  }

  if ($facts['os']['family'] == 'RedHat') and (versioncmp($facts['os']['release']['major'], '7') < 0) {
    fail(translate('This module only works on Red Hat based systems version 7 and higher.'))
  }

  if ($default_gateway) and (!$bridge) {
    fail(translate('You must provide the $bridge parameter.'))
  }

  if $log_level {
    assert_type(Pattern[/^(debug|info|warn|error|fatal)$/], $log_level) |$a, $b| {
      fail(translate('log_level must be one of debug, info, warn, error or fatal'))
    }
  }

  if $log_driver {
    if $facts['os']['family'] == 'windows' {
      assert_type(Pattern[/^(none|json-file|syslog|gelf|fluentd|splunk|awslogs|etwlogs)$/], $log_driver) |$a, $b| {
        fail(translate('log_driver must be one of none, json-file, syslog, gelf, fluentd, splunk, awslogs or etwlogs'))
      }
    } else {
      assert_type(Pattern[/^(none|json-file|syslog|journald|gelf|fluentd|splunk|awslogs)$/], $log_driver) |$a, $b| {
        fail(translate('log_driver must be one of none, json-file, syslog, journald, gelf, fluentd, splunk or awslogs'))
      }
    }
  }

  if $storage_driver {
    if $facts['os']['family'] == 'windows' {
      assert_type(Pattern[/^(windowsfilter)$/], $storage_driver) |$a, $b| {
        fail(translate('Valid values for storage_driver on windows are windowsfilter'))
      }
    } else {
      assert_type(Pattern[/^(aufs|devicemapper|btrfs|overlay|overlay2|vfs|zfs)$/], $storage_driver) |$a, $b| {
        fail(translate('Valid values for storage_driver are aufs, devicemapper, btrfs, overlay, overlay2, vfs, zfs.'))
      }
    }
  }

  if ($bridge) and ($facts['os']['family'] == 'windows') {
      assert_type(Pattern[/^(none|nat|transparent|overlay|l2bridge|l2tunnel)$/], $bridge) |$a, $b| {
        fail(translate('bridge must be one of none, nat, transparent, overlay, l2bridge or l2tunnel on Windows.'))
    }
  }

  if $dm_fs {
    assert_type(Pattern[/^(ext4|xfs)$/], $dm_fs) |$a, $b| {
      fail(translate('Only ext4 and xfs are supported currently for dm_fs.'))
    }
  }

  if ($dm_loopdatasize or $dm_loopmetadatasize) and ($dm_datadev or $dm_metadatadev) {
    fail(translate('You should provide parameters only for loop lvm or direct lvm, not both.'))
  }

  if ($dm_datadev or $dm_metadatadev) and $dm_thinpooldev {
    fail(translate('You can use the $dm_thinpooldev parameter, or the $dm_datadev and $dm_metadatadev parameter pair, but you cannot use both.')) # lint:ignore:140chars
  }

  if ($dm_datadev or $dm_metadatadev) {
    notice('The $dm_datadev and $dm_metadatadev parameter pair are deprecated.  The $dm_thinpooldev parameter should be used instead.')
  }

  if ($dm_datadev and !$dm_metadatadev) or (!$dm_datadev and $dm_metadatadev) {
    fail(translate('You need to provide both $dm_datadev and $dm_metadatadev parameters for direct lvm.'))
  }

  if ($dm_basesize or $dm_fs or $dm_mkfsarg or $dm_mountopt or $dm_blocksize or $dm_loopdatasize or $dm_loopmetadatasize or $dm_datadev or $dm_metadatadev) and ($storage_driver != 'devicemapper') {
    fail(translate('Values for dm_ variables will be ignored unless storage_driver is set to devicemapper.'))
  }

  if($tls_enable) {
    if(! $tcp_bind) {
      fail(translate('You need to provide tcp bind parameter for TLS.'))
    }
  }

  if ($version == undef) or ($version !~ /^(17[.][0-1][0-9][.][0-1](~|-|\.)ce|1.\d+)/) {
    if ($docker_ee) {
      $package_location         = $docker::docker_ee_source_location
      $package_key_source       = $docker::docker_ee_key_source
      $package_key_check_source = true
      $package_key              = $docker::docker_ee_key_id
      $package_repos            = $docker::docker_ee_repos
      $release                  = $docker::docker_ee_release
      $docker_start_command     = $docker::docker_ee_start_command
      $docker_package_name      = $docker::docker_ee_package_name
    } else {
      case $facts['os']['family'] {
        'Debian' : {
          $package_location   = $docker_ce_source_location
          $package_key_source = $docker_ce_key_source
          $package_key        = $docker_ce_key_id
          $package_repos      = $docker_ce_channel
          $release            = $docker_ce_release
        }
        'RedHat' : {
          $package_location         = $docker_ce_source_location
          $package_key_source       = $docker_ce_key_source
          $package_key_check_source = true
        }
        'windows': {
          fail(translate('This module only work for Docker Enterprise Edition on Windows.'))
        }
        default: {
          $package_location         = $docker_package_location
          $package_key_source       = $docker_package_key_source
          $package_key_check_source = $docker_package_key_check_source
        }
      }

      $docker_start_command = $docker_ce_start_command
      $docker_package_name  = $docker_ce_package_name
    }
  } else {
    case $facts['os']['family'] {
      'Debian': {
        $package_location         = $docker_package_location
        $package_key_source       = $docker_package_key_source
        $package_key_check_source = $docker_package_key_check_source
        $package_key              = $docker_package_key_id
        $package_repos            = 'main'
        $release                  = $docker_package_release
      }
      'RedHat': {
        $package_location         = $docker_package_location
        $package_key_source       = $docker_package_key_source
        $package_key_check_source = $docker_package_key_check_source
      }
      default: {
        $package_location         = $docker_package_location
        $package_key_source       = $docker_package_key_source
        $package_key_check_source = $docker_package_key_check_source
      }
    }

    $docker_start_command = $docker_engine_start_command
    $docker_package_name  = $docker_engine_package_name
  }

  if ($version != undef) and ($version =~ /^(17[.]0[0-4]|1.\d+)/) {
    $root_dir_flag = '-g'
  } else {
    $root_dir_flag = '--data-root'
  }


  if $ensure != 'absent' {
    contain docker::repos
    contain docker::install
    contain docker::config
    contain docker::service

    create_resources(
      'docker::registry',
      lookup("${module_name}::registries", Hash, 'deep', {}),
    )

    create_resources(
      'docker::image',
      lookup("${module_name}::images", Hash, 'deep', {}),
    )

    create_resources(
      'docker::run',
      lookup("${module_name}::runs", Hash, 'deep', {}),
    )

    Class['docker::repos']
    -> Class['docker::install']
    -> Class['docker::config']
    -> Class['docker::service']
    -> Docker::Registry <||>
    -> Docker::Image <||>
    -> Docker::Run <||>
  } else {
    contain 'docker::repos'
    contain 'docker::install'

    Class['docker::repos'] -> Class['docker::install']
  }
}
