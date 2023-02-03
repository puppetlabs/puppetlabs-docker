# frozen_string_literal: true

require 'spec_helper'

tests = {
  'with default values' => {
  },
  'with docker_users set' => {
    'docker_users' => [
      'some_random_user',
      'foo',
      'bar',
    ],
  },
  'with package_source set to docker-engine' => {
    'package_source' => 'docker-engine',
  },
  'with package_source set to docker-ce' => {
    'package_source' => 'docker-ce',
  },
  'with ensure set to absent' => {
    'ensure' => 'absent',
  },
  'with ensure set to absent and given version' => {
    'ensure'  => 'absent',
    'version' => '16',
  },
  'with ms parameter set' => {
    'version'                        => '16',
    'docker_msft_provider_version'   => '123',
    'nuget_package_provider_version' => '41',
  },
  'with keyring set to optional path' => {
    'keyring' => '/root/keyrings/docker.gpg',
  },
}

describe 'docker', type: :class do
  on_supported_os.each do |os, os_facts|
    ##
    ## set some needed facts
    ##
    if %r{windows}.match?(os)
      facts = windows_facts.merge(os_facts)

      default_params = {
        'docker_ee'    => true,
        'docker_users' => [],
      }
    else
      facts = os_facts

      default_params = {
        'docker_users' => [],
      }
    end

    ##
    ## get default values based on facts
    ##
    defaults = get_defaults(facts)

    context "on #{os}" do
      tests.each do |title, local_params|
        context title do
          params = {
            'acknowledge_unsupported_os'        => false,
            'apt_source_pin_level'              => defaults['apt_source_pin_level'],
            'bip'                               => defaults['bip'],
            'bridge'                            => defaults['bridge'],
            'create_user'                       => true,
            'daemon_environment_files'          => [],
            'default_gateway_ipv6'              => defaults['default_gateway_ipv6'],
            'default_gateway'                   => defaults['default_gateway'],
            'dependent_packages'                => defaults['dependent_packages'],
            'dm_basesize'                       => defaults['dm_basesize'],
            'dm_blkdiscard'                     => defaults['dm_blkdiscard'],
            'dm_blocksize'                      => defaults['dm_blocksize'],
            'dm_datadev'                        => defaults['dm_datadev'],
            'dm_fs'                             => defaults['dm_fs'],
            'dm_loopdatasize'                   => defaults['dm_loopdatasize'],
            'dm_loopmetadatasize'               => defaults['dm_loopmetadatasize'],
            'dm_metadatadev'                    => defaults['dm_metadatadev'],
            'dm_mkfsarg'                        => defaults['dm_mkfsarg'],
            'dm_mountopt'                       => defaults['dm_mountopt'],
            'dm_override_udev_sync_check'       => defaults['dm_override_udev_sync_check'],
            'dm_thinpooldev'                    => defaults['dm_thinpooldev'],
            'dm_use_deferred_deletion'          => defaults['dm_use_deferred_deletion'],
            'dm_use_deferred_removal'           => defaults['dm_use_deferred_removal'],
            'dns_search'                        => defaults['dns_search'],
            'dns'                               => defaults['dns'],
            'docker_ce_channel'                 => defaults['docker_ce_channel'],
            'docker_ce_key_id'                  => defaults['package_ce_key_id'],
            'docker_ce_key_source'              => defaults['package_ce_key_source'],
            'docker_ce_package_name'            => defaults['docker_ce_package_name'],
            'docker_ce_cli_package_name'        => defaults['docker_ce_cli_package_name'],
            'docker_ce_release'                 => defaults['package_ce_release'],
            'docker_ce_source_location'         => defaults['package_ce_source_location'],
            'docker_ce_start_command'           => defaults['docker_ce_start_command'],
            'docker_ee_key_id'                  => defaults['package_ee_key_id'],
            'docker_ee_key_source'              => defaults['package_ee_key_source'],
            'docker_ee_package_name'            => defaults['package_ee_package_name'],
            'docker_ee_release'                 => defaults['package_ee_release'],
            'docker_ee_repos'                   => defaults['package_ee_repos'],
            'docker_ee_source_location'         => defaults['package_ee_source_location'],
            'docker_ee'                         => defaults['docker_ee'],
            'docker_engine_package_name'        => defaults['docker_engine_package_name'],
            'docker_engine_start_command'       => defaults['docker_engine_start_command'],
            'docker_group'                      => defaults['docker_group'],
            'docker_msft_provider_version'      => defaults['docker_msft_provider_version'],
            'docker_package_key_check_source'   => defaults['package_key_check_source'],
            'docker_package_key_id'             => defaults['package_key_id'],
            'docker_package_key_source'         => defaults['package_key_source'],
            'docker_package_location'           => defaults['package_source_location'],
            'docker_package_release'            => defaults['package_release'],
            'docker_users'                      => [],
            'ensure'                            => defaults['package_ensure'],
            'execdriver'                        => defaults['execdriver'],
            'extra_parameters'                  => :undef,
            'fixed_cidr'                        => defaults['fixed_cidr'],
            'icc'                               => defaults['icc'],
            'ip_forward'                        => defaults['ip_forward'],
            'ip_masq'                           => defaults['ip_masq'],
            'iptables'                          => defaults['iptables'],
            'ipv6_cidr'                         => defaults['ipv6_cidr'],
            'ipv6'                              => defaults['ipv6'],
            'labels'                            => defaults['labels'],
            'log_driver'                        => defaults['log_driver'],
            'log_level'                         => defaults['log_level'],
            'log_opt'                           => defaults['log_opt'],
            'manage_package'                    => defaults['manage_package'],
            'manage_service'                    => defaults['manage_service'],
            'mtu'                               => defaults['mtu'],
            'no_proxy'                          => defaults['no_proxy'],
            'nuget_package_provider_version'    => defaults['nuget_package_provider_version'],
            'os_lc'                             => defaults['os_lc'],
            'overlay2_override_kernel_check'    => defaults['overlay2_override_kernel_check'],
            'package_release'                   => defaults['package_release'],
            'package_source'                    => defaults['package_source'],
            'pin_upstream_package_source'       => defaults['pin_upstream_package_source'],
            'prerequired_packages'              => defaults['prerequired_packages'],
            'proxy'                             => defaults['proxy'],
            'registry_mirror'                   => defaults['registry_mirror'],
            'repo_opt'                          => defaults['repo_opt'],
            'root_dir'                          => defaults['root_dir'],
            'selinux_enabled'                   => defaults['selinux_enabled'],
            'service_after_override'            => defaults['service_after_override'],
            'service_config_template'           => defaults['service_config_template'],
            'service_config'                    => defaults['service_config'],
            'service_enable'                    => defaults['service_enable'],
            'service_hasrestart'                => defaults['service_hasrestart'],
            'service_hasstatus'                 => defaults['service_hasstatus'],
            'service_name'                      => defaults['service_name'],
            'service_overrides_template'        => defaults['service_overrides_template'],
            'service_provider'                  => defaults['service_provider'],
            'service_state'                     => defaults['service_state'],
            'shell_values'                      => :undef,
            'socket_bind'                       => defaults['socket_bind'],
            'socket_group'                      => defaults['socket_group'],
            'socket_override'                   => defaults['socket_override'],
            'socket_overrides_template'         => defaults['socket_overrides_template'],
            'storage_auto_extend_pool'          => defaults['storage_auto_extend_pool'],
            'storage_chunk_size'                => defaults['storage_chunk_size'],
            'storage_config_template'           => defaults['storage_config_template'],
            'storage_config'                    => defaults['storage_config'],
            'storage_data_size'                 => defaults['storage_data_size'],
            'storage_devs'                      => defaults['storage_devs'],
            'storage_driver'                    => defaults['storage_driver'],
            'storage_growpart'                  => defaults['storage_growpart'],
            'storage_min_data_size'             => defaults['storage_min_data_size'],
            'storage_pool_autoextend_percent'   => defaults['storage_pool_autoextend_percent'],
            'storage_pool_autoextend_threshold' => defaults['storage_pool_autoextend_threshold'],
            'storage_root_size'                 => defaults['storage_root_size'],
            'storage_setup_file'                => defaults['storage_setup_file'],
            'storage_vg'                        => defaults['storage_vg'],
            'tcp_bind'                          => defaults['tcp_bind'],
            'tls_cacert'                        => defaults['tls_cacert'],
            'tls_cert'                          => defaults['tls_cert'],
            'tls_enable'                        => defaults['tls_enable'],
            'tls_key'                           => defaults['tls_key'],
            'tls_verify'                        => defaults['tls_verify'],
            'tmp_dir_config'                    => defaults['tmp_dir_config'],
            'tmp_dir'                           => defaults['tmp_dir'],
            'use_upstream_package_source'       => defaults['use_upstream_package_source'],
            'version'                           => defaults['version'],
            'keyring'                           => defaults['keyring'],
          }.merge(default_params).merge(local_params)

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          if params['ensure'] != 'absent'
            if params['package_source'] != :undef && facts[:os]['family'].include?('windows')
              it {
                is_expected.to compile.and_raise_error(%r{Custom package source is currently not implemented on windows.})
              }
            else
              it {
                is_expected.to contain_class('docker::repos').that_comes_before('Class[docker::install]')
                is_expected.to contain_class('docker::install').that_comes_before('Class[docker::config]')
                is_expected.to contain_class('docker::config').that_comes_before('Class[docker::service]')
                is_expected.to contain_class('docker::service')
              }

              include_examples 'params', facts
              include_examples 'repos', params, facts
              include_examples 'install', params, facts
              include_examples 'config', params, facts
              include_examples 'service', params, facts
            end
          else
            it {
              is_expected.to contain_class('docker::repos').that_comes_before('Class[docker::install]')
              is_expected.to contain_class('docker::install')
            }

            include_examples 'params', facts
            include_examples 'repos', params, facts
            include_examples 'install', params, facts
          end
        end
      end
    end
  end
end
