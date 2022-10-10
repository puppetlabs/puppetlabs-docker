# frozen_string_literal: true

require 'spec_helper'

tests = {
  'default values' => {},
  'when passing depends containers' => {
    'depends' => [
      'foo',
      'bar',
      'foo_bar/baz',
    ],
  },
  'when passing after containers' => {
    'after' => [
      'foo',
      'bar',
      'foo_bar/baz',
    ],
  },
  'when use_name is true' => {
    'use_name' => true,
  },
  'when stopping the service' => {
    'running' => false,
  },
  'when passing a cpuset' => {
    'cpuset' => '3',
  },
  'when passing a multiple cpu cpuset' => {
    'cpuset' => [
      '0',
      '3',
    ],
  },
  'when passing a links option' => {
    'links' => [
      'example:one',
      'example:two',
    ],
  },
  'when passing a hostname' => {
    'hostname' => 'example.com',
  },
  'when passing a username' => {
    'username' => 'bob',
  },
  'when passing a port number' => {
    'ports' => '4444',
  },
  'when passing a port to expose' => {
    'expose' => '4666',
  },
  'when passing a label' => {
    'labels' => 'key=value',
  },
  'when passing a hostentry' => {
    'hostentries' => 'dummyhost:127.0.0.2',
  },
  'when connecting to shared data volumes' => {
    'volumes_from' => '6446ea52fbc9',
  },
  'when connecting to several shared data volumes' => {
    'volumes_from' => [
      'sample-linked-container-1',
      'sample-linked-container-2',
    ],
  },
  'when passing several port numbers' => {
    'ports' => [
      '4444',
      '4555',
    ],
  },
  'when passing several labels' => {
    'labels' => [
      'key1=value1',
      'key2=value2',
    ],
  },
  'when passing several ports to expose' => {
    'expose' => [
      '4666',
      '4777',
    ],
  },
  'when passing serveral environment variables' => {
    'env' => [
      'FOO=BAR',
      'FOO2=BAR2',
    ],
  },
  'when passing an environment variable' => {
    'env' => 'FOO=BAR',
  },
  'when passing serveral environment files' => {
    'env_file' => [
      '/etc/foo.env',
      '/etc/bar.env',
    ],
  },
  'when passing an environment file' => {
    'env_file' => '/etc/foo.env',
  },
  'when passing serveral dns addresses' => {
    'dns' => [
      '8.8.8.8',
      '8.8.4.4',
    ],
  },
  'when passing a dns address' => {
    'dns' => '8.8.8.8',
  },
  'when passing serveral sockets to connect to' => {
    'socket_connect' => [
      'tcp://127.0.0.1:4567',
      'tcp://127.0.0.2:4567',
    ],
  },
  'when passing a socket to connect to' => {
    'socket_connect' => 'tcp://127.0.0.1:4567',
  },
  'when passing serveral dns search domains' => {
    'dns_search' => [
      'my.domain.local',
      'other-domain.de',
    ],
  },
  'when passing a dns search domain' => {
    'dns_search' => 'my.domain.local',
  },
  'when disabling network' => {
    'disable_network' => true,
  },
  'when running privileged' => {
    'privileged' => true,
  },
  'when passing serveral extra parameters' => {
    'extra_parameters' => ['--rm', '-w /tmp'],
  },
  'when passing an extra parameter' => {
    'extra_parameters' => '-c 4',
  },
  'when passing a data volume' => {
    'volumes' => '/var/log',
  },
  'when passing serveral data volume' => {
    'volumes' => [
      '/var/lib/couchdb',
      '/var/log',
    ],
  },
  'when pull_on_start is true' => {
    'pull_on_start' => true,
  },
  'when pull_on_start is false' => {
    'pull_on_start' => false,
  },
  'when before_start is set' => {
    'before_start' => 'echo before_start',
  },
  'when before_start is not set' => {
    'before_start' => false,
  },
  'when before_stop is set' => {
    'before_stop' => 'echo before_stop',
  },
  'when before_stop is not set' => {
    'before_stop' => false,
  },
  'when after_start is set' => {
    'after_start' => 'echo after_start',
  },
  'when after_start is not set' => {
    'after_start' => false,
  },
  'when after_stop is set' => {
    'after_stop' => 'echo after_stop',
  },
  'when after_stop is not set' => {
    'after_stop' => false,
  },
  'when docker_service is false' => {
    'docker_service' => false,
  },
  'when docker_service is true' => {
    'docker_service' => true,
  },
  'when docker_service is true and restart_service_on_docker_refresh is false' => {
    'docker_service' => true,
    'restart_service_on_docker_refresh' => false,
  },
  'when docker_service is my-docker' => {
    'docker_service' => 'my-docker',
  },
  'when docker_service is my-docker and restart_service_on_docker_refresh is false' => {
    'docker_service' => 'my-docker',
    'restart_service_on_docker_refresh' => false,
  },
  'when passing syslog_facility' => {
    'syslog_facility' => 'user',
  },
  'when passing serveral extra systemd parameters' => {
    'extra_systemd_parameters' => {
      'Service' => {
        'TimeoutStopSec' => '120',
      },
      'Unit' => {
        'Documentation' => 'https://example.com/'
      },
      'Install' => {
        'Alias' => 'example2',
      },
    }
  },
  'when passing an extra systemd parameter' => {
    'extra_systemd_parameters' => {
      'Service' => {
        'TimeoutStopSec' => '120',
      }
    }
  },
}

describe 'docker::run', type: :define do
  on_supported_os.each do |os, os_facts|
    ##
    ## set some needed facts
    ##
    if %r{windows}.match?(os)
      facts = windows_facts.merge(os_facts)
      facts = facts.merge({ puppetversion: Puppet.version })

      os_params = {
        'restart' => 'no',
        'extra_parameters' => '-c 4',
      }

      docker_params = {
        'docker_ee' => true,
      }
    else
      facts = { puppetversion: Puppet.version }.merge(os_facts)

      os_params = {}

      docker_params = {}
    end

    ##
    ## get defaults values from params
    ##
    defaults = get_defaults(facts)

    context "on #{os}" do
      tests.each do |title, local_params|
        context title do
          params = {
            'after_create'                      => :undef,
            'after_service'                     => [],
            'after_start'                       => false,
            'after_stop'                        => false,
            'after'                             => [],
            'before_start'                      => false,
            'before_stop'                       => false,
            'command'                           => 'command',
            'cpuset'                            => [],
            'custom_unless'                     => [],
            'depend_services'                   => ['docker.service'],
            'depends'                           => [],
            'detach'                            => :undef,
            'disable_network'                   => false,
            'dns_search'                        => [],
            'dns'                               => [],
            'docker_service'                    => false,
            'ensure'                            => 'present',
            'env_file'                          => [],
            'env'                               => [],
            'expose'                            => [],
            'extra_parameters'                  => :undef,
            'extra_systemd_parameters'          => {},
            'health_check_cmd'                  => :undef,
            'health_check_interval'             => :undef,
            'hostentries'                       => [],
            'hostname'                          => false,
            'image'                             => 'base',
            'labels'                            => [],
            'links'                             => [],
            'lxc_conf'                          => [],
            'manage_service'                    => true,
            'memory_limit'                      => '0b',
            'net'                               => 'bridge',
            'ports'                             => [],
            'privileged'                        => false,
            'pull_on_start'                     => false,
            'read_only'                         => false,
            'remain_after_exit'                 => :undef,
            'remove_container_on_start'         => true,
            'remove_container_on_stop'          => true,
            'remove_volume_on_start'            => false,
            'remove_volume_on_stop'             => false,
            'restart_on_unhealthy'              => false,
            'restart_service_on_docker_refresh' => true,
            'restart_service'                   => true,
            'restart'                           => :undef,
            'running'                           => true,
            'service_prefix'                    => 'docker-',
            'service_provider'                  => :undef,
            'socket_connect'                    => [],
            'stop_wait_time'                    => 10,
            'syslog_identifier'                 => :undef,
            'systemd_restart'                   => 'on-failure',
            'tty'                               => false,
            'use_name'                          => false,
            'username'                          => false,
            'volumes_from'                      => [],
            'volumes'                           => [],
          }.merge(os_params).merge(local_params)

          if params['docker_service'] && params['docker_service'].to_s != 'true'
            docker_params['service_name'] = params['docker_service']
          end

          let(:facts) do
            facts
          end

          let(:params) do
            params
          end

          let(:title) do
            params['command']
          end

          let :pre_condition do
            <<-MANIFEST
            class { 'docker':
              version => "#{params['version']}",
              *       => #{docker_params},
            }
            MANIFEST
          end

          if params['remove_volume_on_start'] && !params['remove_container_on_start']
            it {
              is_expected.to compile.and_raise_error("In order to remove the volume on start for #{_title} you need to also remove the container")
            }

            next
          end

          if params['remove_volume_on_stop'] && !params['remove_container_on_stop']
            it {
              is_expected.to compile.and_raise_error("In order to remove the volume on stop for #{_title} you need to also remove the container")
            }

            next
          end

          service_provider_real = case params['service_provider']
                                  when :undef
                                    defaults['service_provider']
                                  else
                                    params['service_provider']
                                  end

          if !params['service_provider_real'] == 'systemd' && !params['service_provider_real'] == 'upstart'
            if facts[:os]['family'] != 'windows'
              it {
                is_expected.to compile.and_raise_error('Docker needs a Debian or RedHat based system.')
              }

              next
            elsif params['ensure'] == 'present'
              it {
                is_expected.to compile.and_raise_error('Restart parameter is required for Windows')
              }

              next
            end
          end

          include_examples 'run', params['command'], params, facts, defaults
        end
      end
    end
  end
end
