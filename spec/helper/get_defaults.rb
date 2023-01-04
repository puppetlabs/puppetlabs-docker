# frozen_string_literal: true

def get_defaults(_facts)
  bip                               = :undef
  bridge                            = :undef
  compose_base_url                  = 'https://github.com/docker/compose/releases/download'
  compose_symlink_name              = 'docker-compose'
  curl_ensure                       = true
  default_gateway                   = :undef
  default_gateway_ipv6              = :undef
  dm_basesize                       = :undef
  dm_blkdiscard                     = :undef
  dm_blocksize                      = :undef
  dm_datadev                        = :undef
  dm_fs                             = :undef
  dm_loopdatasize                   = :undef
  dm_loopmetadatasize               = :undef
  dm_metadatadev                    = :undef
  dm_mkfsarg                        = :undef
  dm_mountopt                       = :undef
  dm_override_udev_sync_check       = :undef
  dm_thinpooldev                    = :undef
  dm_use_deferred_deletion          = :undef
  dm_use_deferred_removal           = :undef
  dns                               = :undef
  dns_search                        = :undef
  docker_ce_channel                 = 'stable'
  docker_ce_package_name            = 'docker-ce'
  docker_ce_cli_package_name        = 'docker-ce-cli'
  docker_ce_start_command           = 'dockerd'
  docker_command                    = 'docker'
  docker_ee                         = false
  docker_ee_key_id                  = :undef
  docker_ee_key_source              = :undef
  docker_ee_repos                   = 'stable'
  docker_ee_source_location         = :undef
  docker_ee_start_command           = 'dockerd'
  docker_engine_package_name        = 'docker-engine'
  docker_engine_start_command       = 'docker daemon'
  docker_group_default              = 'docker'
  docker_msft_provider_version      = :undef
  package_ensure                    = 'present'
  execdriver                        = :undef
  fixed_cidr                        = :undef
  icc                               = :undef
  ip_forward                        = true
  ip_masq                           = true
  iptables                          = true
  ipv6                              = false
  ipv6_cidr                         = :undef
  labels                            = []
  log_driver                        = :undef
  log_level                         = :undef
  log_opt                           = []
  machine_version                   = '0.16.1'
  manage_package                    = true
  manage_service                    = true
  mtu                               = :undef
  no_proxy                          = :undef
  nuget_package_provider_version    = :undef
  os_lc                             = _facts[:os]['name']
  overlay2_override_kernel_check    = false
  package_source                    = :undef
  proxy                             = :undef
  registry_mirror                   = :undef
  root_dir                          = :undef
  selinux_enabled                   = :undef
  service_enable                    = true
  service_name_default              = 'docker'
  service_state                     = 'running'
  socket_bind                       = 'unix:///var/run/docker.sock'
  socket_group_default              = 'docker'
  storage_auto_extend_pool          = :undef
  storage_chunk_size                = :undef
  storage_config_template           = 'docker/etc/sysconfig/docker-storage.erb'
  storage_data_size                 = :undef
  storage_devs                      = :undef
  storage_driver                    = :undef
  storage_growpart                  = :undef
  storage_min_data_size             = :undef
  storage_pool_autoextend_percent   = :undef
  storage_pool_autoextend_threshold = :undef
  storage_root_size                 = :undef
  storage_vg                        = :undef
  tcp_bind                          = :undef
  tls_enable                        = false
  tls_verify                        = true
  tmp_dir                           = '/tmp/'
  tmp_dir_config                    = true
  version                           = :undef
  keyring                           = '/etc/apt/keyrings/docker.gpg'

  if _facts[:os]['family'] == 'windows'
    compose_install_path   = "#{_facts['docker_program_files_path']}/Docker"
    compose_version        = '1.21.2'
    docker_ee_package_name = 'Docker'
    machine_install_path   = "#{_facts['docker_program_files_path']}/Docker"
    tls_cacert             = "#{_facts['docker_program_data_path']}/docker/certs.d/ca.pem"
    tls_cert               = "#{_facts['docker_program_data_path']}/docker/certs.d/server-cert.pem"
    tls_key                = "#{_facts['docker_program_data_path']}/docker/certs.d/server-key.pem"
  else
    compose_install_path   = '/usr/local/bin'
    compose_version        = '1.9.0'
    docker_ee_package_name = 'docker-ee'
    machine_install_path   = '/usr/local/bin'
    tls_cacert             = '/etc/docker/tls/ca.pem'
    tls_cert               = '/etc/docker/tls/cert.pem'
    tls_key                = '/etc/docker/tls/key.pem'
  end

  case _facts[:os]['family']
  when 'Debian'
    case _facts[:os]['name']
    when 'Ubuntu'
      package_release = "ubuntu-#{_facts[:os]['distro']['codename']}"
      service_after_override     = :undef
      service_config_template    = 'docker/etc/sysconfig/docker.systemd.erb'
      service_hasrestart         = true
      service_hasstatus          = true
      service_overrides_template = 'docker/etc/systemd/system/docker.service.d/service-overrides-debian.conf.erb'
      service_provider           = 'systemd'
      socket_override            = false
      socket_overrides_template  = 'docker/etc/systemd/system/docker.socket.d/socket-overrides.conf.erb'
      storage_config             = '/etc/default/docker-storage'
    else
      package_release            = "debian-#{_facts[:os]['distro']['codename']}"
      service_after_override     = :undef
      service_config_template    = 'docker/etc/sysconfig/docker.systemd.erb'
      service_hasrestart         = true
      service_hasstatus          = true
      service_overrides_template = 'docker/etc/systemd/system/docker.service.d/service-overrides-debian.conf.erb'
      service_provider           = 'systemd'
      socket_override            = false
      socket_overrides_template  = 'docker/etc/systemd/system/docker.socket.d/socket-overrides.conf.erb'
      storage_config             = '/etc/default/docker-storage'
    end

    apt_source_pin_level          = 500
    docker_group                  = docker_group_default
    pin_upstream_package_source   = true
    repo_opt                      = :undef
    service_config                = :undef
    service_name                  = service_name_default
    socket_group                  = socket_group_default
    storage_setup_file            = :undef
    use_upstream_package_source   = true

    package_ce_key_id             = '9DC858229FC7DD38854AE2D88D81803C0EBFCD88'
    package_ce_key_source         = "https://download.docker.com/linux/#{os_lc}/gpg"
    package_ce_release            = _facts[:os]['distro']['codename']
    package_ce_source_location    = "https://download.docker.com/linux/#{os_lc}"
    package_ee_key_id             = docker_ee_key_id
    package_ee_key_source         = docker_ee_key_source
    package_ee_package_name       = docker_ee_package_name
    package_ee_release            = _facts[:os]['distro']['codename']
    package_ee_repos              = docker_ee_repos
    package_ee_source_location    = docker_ee_source_location
    package_key_check_source      = :undef
    package_key_id                = '58118E89F3A912897C070ADBF76221572C52609D'
    package_key_source            = 'https://apt.dockerproject.org/gpg'
    package_source_location       = 'http://apt.dockerproject.org/repo'

    detach_service_in_init = if service_provider == 'systemd'
                               false
                             else
                               true
                             end
  when 'RedHat'
    service_after_override      = :undef
    service_config              = '/etc/sysconfig/docker'
    service_config_template     = 'docker/etc/sysconfig/docker.systemd.erb'
    service_hasrestart          = true
    service_hasstatus           = true
    service_overrides_template  = 'docker/etc/systemd/system/docker.service.d/service-overrides-rhel.conf.erb'
    service_provider            = 'systemd'
    socket_override             = false
    socket_overrides_template   = 'docker/etc/systemd/system/docker.socket.d/socket-overrides.conf.erb'
    storage_config              = '/etc/sysconfig/docker-storage'
    storage_setup_file          = '/etc/sysconfig/docker-storage-setup'
    use_upstream_package_source = true

    apt_source_pin_level        = :undef
    detach_service_in_init      = false
    package_ce_key_id           = :undef
    package_ce_key_source       = 'https://download.docker.com/linux/centos/gpg'
    package_ce_release          = :undef
    package_ce_source_location  = "https://download.docker.com/linux/centos/#{_facts[:os]['release']['major']}/#{_facts[:os]['architecture']}/#{docker_ce_channel}"
    package_ee_key_id           = docker_ee_key_id
    package_ee_key_source       = docker_ee_key_source
    package_ee_package_name     = docker_ee_package_name
    package_ee_release          = :undef
    package_ee_repos            = docker_ee_repos
    package_ee_source_location  = docker_ee_source_location
    package_key_check_source    = true
    package_key_id              = :undef
    package_key_source          = 'https://yum.dockerproject.org/gpg'
    package_release             = :undef
    package_source_location     = "https://yum.dockerproject.org/repo/main/centos/#{_facts[:os]['release']['major']}"
    pin_upstream_package_source = :undef
    service_name                = service_name_default

    if use_upstream_package_source
      docker_group = docker_group_default
      socket_group = socket_group_default
    else
      docker_group = 'dockerroot'
      socket_group = 'dockerroot'
    end

    # repo_opt to specify install_options for docker package
    repo_opt = if _facts[:os]['name'] == 'RedHat'
                 '--enablerepo=rhel-7-server-extras-rpms'
               else
                 :undef
               end
  when 'windows'
    msft_nuget_package_provider_version = nuget_package_provider_version
    msft_provider_version               = docker_msft_provider_version
    msft_package_version                = version
    service_config_template             = 'docker/windows/config/daemon.json.erb'
    service_config                      = "#{_facts['docker_program_data_path']}/docker/config/daemon.json"
    docker_group                        = 'docker'
    package_ce_source_location          = :undef
    package_ce_key_source               = :undef
    package_ce_key_id                   = :undef
    package_ce_repos                    = :undef
    package_ce_release                  = :undef
    package_key_id                      = :undef
    package_release                     = :undef
    package_source_location             = :undef
    package_key_source                  = :undef
    package_key_check_source            = :undef
    package_ee_source_location          = :undef
    package_ee_package_name             = docker_ee_package_name
    package_ee_key_source               = :undef
    package_ee_key_id                   = :undef
    package_ee_repos                    = :undef
    package_ee_release                  = :undef
    use_upstream_package_source         = :undef
    pin_upstream_package_source         = :undef
    apt_source_pin_level                = :undef
    socket_group                        = :undef
    service_name                        = service_name_default
    repo_opt                            = :undef
    storage_config                      = :undef
    storage_setup_file                  = :undef
    service_provider                    = :undef
    service_overrides_template          = :undef
    socket_overrides_template           = :undef
    socket_override                     = false
    service_after_override              = :undef
    service_hasstatus                   = :undef
    service_hasrestart                  = :undef
    detach_service_in_init              = true
  when 'Suse'
    docker_group                        = docker_group_default
    socket_group                        = socket_group_default
    package_key_source                  = :undef
    package_key_check_source            = :undef
    package_source_location             = :undef
    package_key_id                      = :undef
    package_repos                       = :undef
    package_release                     = :undef
    package_ce_key_source               = :undef
    package_ce_source_location          = :undef
    package_ce_key_id                   = :undef
    package_ce_repos                    = :undef
    package_ce_release                  = :undef
    package_ee_source_location          = :undef
    package_ee_key_source               = :undef
    package_ee_key_id                   = :undef
    package_ee_release                  = :undef
    package_ee_repos                    = :undef
    package_ee_package_name             = :undef
    use_upstream_package_source         = true
    service_overrides_template          = :undef
    socket_overrides_template           = :undef
    socket_override                     = false
    service_after_override              = :undef
    service_hasstatus                   = :undef
    service_hasrestart                  = :undef
    service_provider                    = 'systemd'
    package_name                        = docker_ce_package_name
    service_name                        = service_name_default
    detach_service_in_init              = true
    repo_opt                            = :undef
    nowarn_kernel                       = false
    service_config                      = :undef
    storage_config                      = :undef
    storage_setup_file                  = :undef
    service_config_template             = :undef
    pin_upstream_package_source         = :undef
    apt_source_pin_level                = :undef
  else
    docker_group                        = docker_group_default
    socket_group                        = socket_group_default
    package_key_source                  = :undef
    package_key_check_source            = :undef
    package_source_location             = :undef
    package_key_id                      = :undef
    package_repos                       = :undef
    package_release                     = :undef
    package_ce_key_source               = :undef
    package_ce_source_location          = :undef
    package_ce_key_id                   = :undef
    package_ce_repos                    = :undef
    package_ce_release                  = :undef
    package_ee_source_location          = :undef
    package_ee_key_source               = :undef
    package_ee_key_id                   = :undef
    package_ee_release                  = :undef
    package_ee_repos                    = :undef
    package_ee_package_name             = :undef
    use_upstream_package_source         = true
    service_overrides_template          = :undef
    socket_overrides_template           = :undef
    socket_override                     = false
    service_after_override              = :undef
    service_hasstatus                   = :undef
    service_hasrestart                  = :undef
    service_provider                    = :undef
    package_name                        = docker_ce_package_name
    service_name                        = service_name_default
    detach_service_in_init              = true
    repo_opt                            = :undef
    nowarn_kernel                       = false
    service_config                      = :undef
    storage_config                      = :undef
    storage_setup_file                  = :undef
    service_config_template             = :undef
    pin_upstream_package_source         = :undef
    apt_source_pin_level                = :undef
  end

  dependent_packages = [docker_ce_cli_package_name, 'containerd.io']

  prerequired_packages = case _facts[:os]['family']
                         when 'Debian'
                           case _facts[:os]['name']
                           when 'Debian'
                             ['cgroupfs-mount']
                           when 'Ubuntu'
                             ['cgroup-lite', 'apparmor']
                           else
                             []
                           end
                         when 'RedHat'
                           ['device-mapper']
                         else
                           []
                         end

  {
    'apt_source_pin_level' => apt_source_pin_level,
    'bip' => bip,
    'bridge' => bridge,
    'compose_base_url' => compose_base_url,
    'compose_install_path' => compose_install_path,
    'compose_symlink_name' => compose_symlink_name,
    'compose_version' => compose_version,
    'curl_ensure' => curl_ensure,
    'default_gateway' => default_gateway,
    'default_gateway_ipv6' => default_gateway_ipv6,
    'dependent_packages' => dependent_packages,
    'detach_service_in_init' => detach_service_in_init,
    'dm_basesize' => dm_basesize,
    'dm_blkdiscard' => dm_blkdiscard,
    'dm_blocksize' => dm_blocksize,
    'dm_datadev' => dm_datadev,
    'dm_fs' => dm_fs,
    'dm_loopdatasize' => dm_loopdatasize,
    'dm_loopmetadatasize' => dm_loopmetadatasize,
    'dm_metadatadev' => dm_metadatadev,
    'dm_mkfsarg' => dm_mkfsarg,
    'dm_mountopt' => dm_mountopt,
    'dm_override_udev_sync_check' => dm_override_udev_sync_check,
    'dm_thinpooldev' => dm_thinpooldev,
    'dm_use_deferred_deletion' => dm_use_deferred_deletion,
    'dm_use_deferred_removal' => dm_use_deferred_removal,
    'dns' => dns,
    'dns_search' => dns_search,
    'docker_ce_channel' => docker_ce_channel,
    'docker_ce_package_name' => docker_ce_package_name,
    'docker_ce_cli_package_name' => docker_ce_cli_package_name,
    'docker_ce_start_command' => docker_ce_start_command,
    'docker_command' => docker_command,
    'docker_ee' => docker_ee,
    'docker_ee_key_id' => docker_ee_key_id,
    'docker_ee_key_source' => docker_ee_key_source,
    'docker_ee_package_name' => docker_ee_package_name,
    'docker_ee_repos' => docker_ee_repos,
    'docker_ee_source_location' => docker_ee_source_location,
    'docker_ee_start_command' => docker_ee_start_command,
    'docker_engine_package_name' => docker_engine_package_name,
    'docker_engine_start_command' => docker_engine_start_command,
    'docker_group' => docker_group,
    'docker_group_default' => docker_group_default,
    'docker_msft_provider_version' => docker_msft_provider_version,
    'execdriver' => execdriver,
    'fixed_cidr' => fixed_cidr,
    'icc' => icc,
    'ip_forward' => ip_forward,
    'ip_masq' => ip_masq,
    'iptables' => iptables,
    'ipv6' => ipv6,
    'ipv6_cidr' => ipv6_cidr,
    'labels' => labels,
    'log_driver' => log_driver,
    'log_level' => log_level,
    'log_opt' => log_opt,
    'machine_install_path' => machine_install_path,
    'machine_version' => machine_version,
    'manage_package' => manage_package,
    'manage_service' => manage_service,
    'msft_nuget_package_provider_version' => msft_nuget_package_provider_version,
    'msft_package_version' => msft_package_version,
    'msft_provider_version' => msft_provider_version,
    'mtu' => mtu,
    'no_proxy' => no_proxy,
    'nowarn_kernel' => nowarn_kernel,
    'nuget_package_provider_version' => nuget_package_provider_version,
    'os_lc' => os_lc,
    'overlay2_override_kernel_check' => overlay2_override_kernel_check,
    'package_ce_key_id' => package_ce_key_id,
    'package_ce_key_source' => package_ce_key_source,
    'package_ce_release' => package_ce_release,
    'package_ce_repos' => package_ce_repos,
    'package_ce_source_location' => package_ce_source_location,
    'package_ee_key_id' => package_ee_key_id,
    'package_ee_key_source' => package_ee_key_source,
    'package_ee_package_name' => package_ee_package_name,
    'package_ee_release' => package_ee_release,
    'package_ee_repos' => package_ee_repos,
    'package_ee_source_location' => package_ee_source_location,
    'package_ensure' => package_ensure,
    'package_key_check_source' => package_key_check_source,
    'package_key_id' => package_key_id,
    'package_key_source' => package_key_source,
    'package_name' => package_name,
    'package_release' => package_release,
    'package_repos' => package_repos,
    'package_source' => package_source,
    'package_source_location' => package_source_location,
    'pin_upstream_package_source' => pin_upstream_package_source,
    'prerequired_packages' => prerequired_packages,
    'proxy' => proxy,
    'registry_mirror' => registry_mirror,
    'repo_opt' => repo_opt,
    'root_dir' => root_dir,
    'selinux_enabled' => selinux_enabled,
    'service_after_override' => service_after_override,
    'service_config' => service_config,
    'service_config_template' => service_config_template,
    'service_enable' => service_enable,
    'service_hasrestart' => service_hasrestart,
    'service_hasstatus' => service_hasstatus,
    'service_name' => service_name,
    'service_name_default' => service_name_default,
    'service_overrides_template' => service_overrides_template,
    'service_provider' => service_provider,
    'service_state' => service_state,
    'socket_bind' => socket_bind,
    'socket_group' => socket_group,
    'socket_group_default' => socket_group_default,
    'socket_override' => socket_override,
    'socket_overrides_template' => socket_overrides_template,
    'storage_auto_extend_pool' => storage_auto_extend_pool,
    'storage_chunk_size' => storage_chunk_size,
    'storage_config' => storage_config,
    'storage_config_template' => storage_config_template,
    'storage_data_size' => storage_data_size,
    'storage_devs' => storage_devs,
    'storage_driver' => storage_driver,
    'storage_growpart' => storage_growpart,
    'storage_min_data_size' => storage_min_data_size,
    'storage_pool_autoextend_threshold' => storage_pool_autoextend_percent,
    'storage_pool_autoextend_percent' => storage_pool_autoextend_percent,
    'storage_root_size' => storage_root_size,
    'storage_setup_file' => storage_setup_file,
    'storage_vg' => storage_vg,
    'tcp_bind' => tcp_bind,
    'tls_cacert' => tls_cacert,
    'tls_cert' => tls_cert,
    'tls_enable' => tls_enable,
    'tls_key' => tls_key,
    'tls_verify' => tls_verify,
    'tmp_dir' => tmp_dir,
    'tmp_dir_config' => tmp_dir_config,
    'use_upstream_package_source' => use_upstream_package_source,
    'version' => version,
    'keyring' => keyring,
  }
end
