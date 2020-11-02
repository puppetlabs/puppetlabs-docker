# @summary Default parameter values for the docker module
#
class docker::params {
  $version                           = undef
  $ensure                            = present
  $docker_ce_start_command           = 'dockerd'
  $docker_ce_package_name            = 'docker-ce'
  $docker_engine_start_command       = 'docker daemon'
  $docker_engine_package_name        = 'docker-engine'
  $docker_ce_channel                 = stable
  $docker_ee                         = false
  $docker_ee_start_command           = 'dockerd'
  $docker_ee_source_location         = undef
  $docker_ee_key_source              = undef
  $docker_ee_key_id                  = undef
  $docker_ee_repos                   = stable
  $tcp_bind                          = undef
  $tls_enable                        = false
  $tls_verify                        = true
  $machine_version                   = '0.16.1'
  $ip_forward                        = true
  $iptables                          = true
  $ipv6                              = false
  $ipv6_cidr                         = undef
  $default_gateway_ipv6              = undef
  $icc                               = undef
  $ip_masq                           = true
  $bip                               = undef
  $mtu                               = undef
  $fixed_cidr                        = undef
  $bridge                            = undef
  $default_gateway                   = undef
  $socket_bind                       = 'unix:///var/run/docker.sock'
  $log_level                         = undef
  $log_driver                        = undef
  $log_opt                           = []
  $selinux_enabled                   = undef
  $socket_group_default              = 'docker'
  $labels                            = []
  $service_state                     = running
  $service_enable                    = true
  $manage_service                    = true
  $root_dir                          = undef
  $tmp_dir_config                    = true
  $tmp_dir                           = '/tmp/'
  $dns                               = undef
  $dns_search                        = undef
  $proxy                             = undef
  $compose_base_url                  = 'https://github.com/docker/compose/releases/download'
  $compose_symlink_name              = 'docker-compose'
  $no_proxy                          = undef
  $execdriver                        = undef
  $storage_driver                    = undef
  $dm_basesize                       = undef
  $dm_fs                             = undef
  $dm_mkfsarg                        = undef
  $dm_mountopt                       = undef
  $dm_blocksize                      = undef
  $dm_loopdatasize                   = undef
  $dm_loopmetadatasize               = undef
  $dm_datadev                        = undef
  $dm_metadatadev                    = undef
  $dm_thinpooldev                    = undef
  $dm_use_deferred_removal           = undef
  $dm_use_deferred_deletion          = undef
  $dm_blkdiscard                     = undef
  $dm_override_udev_sync_check       = undef
  $overlay2_override_kernel_check    = false
  $manage_package                    = true
  $package_source                    = undef
  $service_name_default              = 'docker'
  $docker_group_default              = 'docker'
  $storage_devs                      = undef
  $storage_vg                        = undef
  $storage_root_size                 = undef
  $storage_data_size                 = undef
  $storage_min_data_size             = undef
  $storage_chunk_size                = undef
  $storage_growpart                  = undef
  $storage_auto_extend_pool          = undef
  $storage_pool_autoextend_threshold = undef
  $storage_pool_autoextend_percent   = undef
  $storage_config_template           = 'docker/etc/sysconfig/docker-storage.erb'
  $registry_mirror                   = undef
  $curl_ensure                       = true
  $os_lc                             = downcase($facts['os']['name'])
  $docker_msft_provider_version      = undef
  $nuget_package_provider_version    = undef
  $docker_command                    = 'docker'

  if ($facts['os']['family'] == 'windows') {
    $compose_install_path   = "${::docker_program_files_path}/Docker"
    $compose_version        = '1.21.2'
    $docker_ee_package_name = 'Docker'
    $machine_install_path   = "${::docker_program_files_path}/Docker"
    $tls_cacert             = "${::docker_program_data_path}/docker/certs.d/ca.pem"
    $tls_cert               = "${::docker_program_data_path}/docker/certs.d/server-cert.pem"
    $tls_key                = "${::docker_program_data_path}/docker/certs.d/server-key.pem"
  } else {
    $compose_install_path   = '/usr/local/bin'
    $compose_version        = '1.21.2'
    $docker_ee_package_name = 'docker-ee'
    $machine_install_path   = '/usr/local/bin'
    $tls_cacert             = '/etc/docker/tls/ca.pem'
    $tls_cert               = '/etc/docker/tls/cert.pem'
    $tls_key                = '/etc/docker/tls/key.pem'
  }

  case $facts['os']['family'] {
    'Debian' : {
      case $facts['os']['name'] {
        'Ubuntu' : {
          $package_release = "ubuntu-${facts['os']['distro']['codename']}"

          if (versioncmp($facts['os']['release']['full'], '15.04') >= 0) {
            $service_after_override     = undef
            $service_config_template    = 'docker/etc/sysconfig/docker.systemd.erb'
            $service_hasrestart         = true
            $service_hasstatus          = true
            $service_overrides_template = 'docker/etc/systemd/system/docker.service.d/service-overrides-debian.conf.erb'
            $service_provider           = 'systemd'
            $socket_override            = false
            $socket_overrides_template  = 'docker/etc/systemd/system/docker.socket.d/socket-overrides.conf.erb'
            $storage_config             = '/etc/default/docker-storage'
            include docker::systemd_reload
          } else {
            $service_config_template    = 'docker/etc/default/docker.erb'
            $service_overrides_template = undef
            $socket_overrides_template  = undef
            $socket_override            = false
            $service_after_override     = undef
            $service_provider           = 'upstart'
            $service_hasstatus          = true
            $service_hasrestart         = false
            $storage_config             = undef
          }
        }
        default: {
          if (versioncmp($facts['facterversion'], '2.4.6') <= 0) {
            $package_release            = "debian-${facts['os']['lsb']['distcodename']}"
          } else {
            $package_release            = "debian-${facts['os']['distro']['codename']}"
          }
          $service_provider           = 'systemd'
          $storage_config             = '/etc/default/docker-storage'
          $service_config_template    = 'docker/etc/sysconfig/docker.systemd.erb'
          $service_overrides_template = 'docker/etc/systemd/system/docker.service.d/service-overrides-debian.conf.erb'
          $socket_overrides_template  = 'docker/etc/systemd/system/docker.socket.d/socket-overrides.conf.erb'
          $socket_override            = false
          $service_after_override     = undef
          $service_hasstatus          = true
          $service_hasrestart         = true

          include docker::systemd_reload
        }
      }

      $apt_source_pin_level          = 500
      $docker_group                  = $docker_group_default
      $pin_upstream_package_source   = true
      $repo_opt                      = undef
      $service_config                = undef
      $service_name                  = $service_name_default
      $socket_group                  = $socket_group_default
      $storage_setup_file            = undef
      $use_upstream_package_source   = true

      $package_ce_source_location    = "https://download.docker.com/linux/${os_lc}"
      $package_ce_key_source         = "https://download.docker.com/linux/${os_lc}/gpg"
      $package_ce_key_id             = '9DC858229FC7DD38854AE2D88D81803C0EBFCD88'
      if (versioncmp($facts['facterversion'], '2.4.6') <= 0) {
        $package_ce_release            = $facts['os']['lsb']['distcodename']
      } else {
        $package_ce_release            = $facts['os']['distro']['codename']
      }
      $package_source_location       = 'http://apt.dockerproject.org/repo'
      $package_key_source            = 'https://apt.dockerproject.org/gpg'
      $package_key_check_source      = undef
      $package_key_id                = '58118E89F3A912897C070ADBF76221572C52609D'
      $package_ee_source_location    = $docker_ee_source_location
      $package_ee_key_source         = $docker_ee_key_source
      $package_ee_key_id             = $docker_ee_key_id
      if (versioncmp($facts['facterversion'], '2.4.6') <= 0) {
        $package_ee_release            = $facts['os']['lsb']['distcodename']
      } else {
        $package_ee_release            = $facts['os']['distro']['codename']
      }
      $package_ee_repos              = $docker_ee_repos
      $package_ee_package_name       = $docker_ee_package_name

      if ($service_provider == 'systemd') {
        $detach_service_in_init = false
      } else {
        $detach_service_in_init = true
      }
    }
    'RedHat' : {
      $service_after_override      = undef
      $service_config              = '/etc/sysconfig/docker'
      $service_config_template     = 'docker/etc/sysconfig/docker.systemd.erb'
      $service_hasrestart          = true
      $service_hasstatus           = true
      $service_overrides_template  = 'docker/etc/systemd/system/docker.service.d/service-overrides-rhel.conf.erb'
      $service_provider            = 'systemd'
      $socket_override             = false
      $socket_overrides_template   = 'docker/etc/systemd/system/docker.socket.d/socket-overrides.conf.erb'
      $storage_config              = '/etc/sysconfig/docker-storage'
      $storage_setup_file          = '/etc/sysconfig/docker-storage-setup'
      $use_upstream_package_source = true

      $apt_source_pin_level        = undef
      $detach_service_in_init      = false
      $package_ce_key_id           = undef
      $package_ce_key_source       = 'https://download.docker.com/linux/centos/gpg'
      $package_ce_release          = undef
      $package_ce_source_location  = "https://download.docker.com/linux/centos/${facts['os']['release']['major']}/${facts['os']['architecture']}/${docker_ce_channel}"
      $package_ee_key_id           = $docker_ee_key_id
      $package_ee_key_source       = $docker_ee_key_source
      $package_ee_package_name     = $docker_ee_package_name
      $package_ee_release          = undef
      $package_ee_repos            = $docker_ee_repos
      $package_ee_source_location  = $docker_ee_source_location
      $package_key_check_source    = true
      $package_key_id              = undef
      $package_key_source          = 'https://yum.dockerproject.org/gpg'
      $package_release             = undef
      $package_source_location     = "https://yum.dockerproject.org/repo/main/centos/${facts['os']['release']['major']}"
      $pin_upstream_package_source = undef
      $service_name                = $service_name_default

      if $use_upstream_package_source {
        $docker_group = $docker_group_default
        $socket_group = $socket_group_default
      } else {
        $docker_group = 'dockerroot'
        $socket_group = 'dockerroot'
      }
      $repo_opt = undef
    }
    'windows' : {
      $msft_nuget_package_provider_version = $nuget_package_provider_version
      $msft_provider_version               = $docker_msft_provider_version
      $msft_package_version                = $version
      $service_config_template             = 'docker/windows/config/daemon.json.erb'
      $service_config                      = "${::docker_program_data_path}/docker/config/daemon.json"
      $docker_group                        = 'docker'
      $package_ce_source_location          = undef
      $package_ce_key_source               = undef
      $package_ce_key_id                   = undef
      $package_ce_repos                    = undef
      $package_ce_release                  = undef
      $package_key_id                      = undef
      $package_release                     = undef
      $package_source_location             = undef
      $package_key_source                  = undef
      $package_key_check_source            = undef
      $package_ee_source_location          = undef
      $package_ee_package_name             = $docker_ee_package_name
      $package_ee_key_source               = undef
      $package_ee_key_id                   = undef
      $package_ee_repos                    = undef
      $package_ee_release                  = undef
      $use_upstream_package_source         = undef
      $pin_upstream_package_source         = undef
      $apt_source_pin_level                = undef
      $socket_group                        = undef
      $service_name                        = $service_name_default
      $repo_opt                            = undef
      $storage_config                      = undef
      $storage_setup_file                  = undef
      $service_provider                    = undef
      $service_overrides_template          = undef
      $socket_overrides_template           = undef
      $socket_override                     = false
      $service_after_override              = undef
      $service_hasstatus                   = undef
      $service_hasrestart                  = undef
      $detach_service_in_init              = true
    }
    'Suse': {
      $docker_group                        = $docker_group_default
      $socket_group                        = $socket_group_default
      $package_key_source                  = undef
      $package_key_check_source            = undef
      $package_source_location             = undef
      $package_key_id                      = undef
      $package_repos                       = undef
      $package_release                     = undef
      $package_ce_key_source               = undef
      $package_ce_source_location          = undef
      $package_ce_key_id                   = undef
      $package_ce_repos                    = undef
      $package_ce_release                  = undef
      $package_ee_source_location          = undef
      $package_ee_key_source               = undef
      $package_ee_key_id                   = undef
      $package_ee_release                  = undef
      $package_ee_repos                    = undef
      $package_ee_package_name             = undef
      $use_upstream_package_source         = true
      $service_overrides_template          = undef
      $socket_overrides_template           = undef
      $socket_override                     = false
      $service_after_override              = undef
      $service_hasstatus                   = undef
      $service_hasrestart                  = undef
      $service_provider                    = 'systemd'
      $package_name                        = $docker_ce_package_name
      $service_name                        = $service_name_default
      $detach_service_in_init              = true
      $repo_opt                            = undef
      $nowarn_kernel                       = false
      $service_config                      = undef
      $storage_config                      = undef
      $storage_setup_file                  = undef
      $service_config_template             = undef
      $pin_upstream_package_source         = undef
      $apt_source_pin_level                = undef
    }
    default: {
      $docker_group                        = $docker_group_default
      $socket_group                        = $socket_group_default
      $package_key_source                  = undef
      $package_key_check_source            = undef
      $package_source_location             = undef
      $package_key_id                      = undef
      $package_repos                       = undef
      $package_release                     = undef
      $package_ce_key_source               = undef
      $package_ce_source_location          = undef
      $package_ce_key_id                   = undef
      $package_ce_repos                    = undef
      $package_ce_release                  = undef
      $package_ee_source_location          = undef
      $package_ee_key_source               = undef
      $package_ee_key_id                   = undef
      $package_ee_release                  = undef
      $package_ee_repos                    = undef
      $package_ee_package_name             = undef
      $use_upstream_package_source         = true
      $service_overrides_template          = undef
      $socket_overrides_template           = undef
      $socket_override                     = false
      $service_after_override              = undef
      $service_hasstatus                   = undef
      $service_hasrestart                  = undef
      $service_provider                    = undef
      $package_name                        = $docker_ce_package_name
      $service_name                        = $service_name_default
      $detach_service_in_init              = true
      $repo_opt                            = undef
      $nowarn_kernel                       = false
      $service_config                      = undef
      $storage_config                      = undef
      $storage_setup_file                  = undef
      $service_config_template             = undef
      $pin_upstream_package_source         = undef
      $apt_source_pin_level                = undef
    }
  }

  # Special extra packages are required on some OSes.
  # Specifically apparmor is needed for Ubuntu:
  # https://github.com/docker/docker/issues/4734
  $prerequired_packages = $facts['os']['family'] ? {
    'Debian' => $facts['os']['name'] ? {
      'Debian' => [ 'cgroupfs-mount', ],
      'Ubuntu' => [ 'cgroup-lite', 'apparmor', ],
      default  => [],
    },
    'RedHat' => ['device-mapper'],
    default  => [],
  }

  $dependent_packages = [ 'docker-ce-cli', 'containerd.io', ]
}
