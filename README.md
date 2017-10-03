# Docker

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with kubernetes](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kubernetes](#beginning-with-kubernetes)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

The Puppet docker module installs, configures, and manages [Docker](https://github.com/docker/docker) from the [official repository](https://docs.docker.com/installation/) or alternatively from [EPEL on RedHat](https://docs.docker.io/en/latest/installation/rhel/) based distributions.

## Description

This module installs, configures, and manages [Docker](https://github.com/docker/docker).

* Debian 8.0
* Debian 9.0
* Ubuntu 14.04
* Ubuntu 16.04
* Centos 7.0

## Usage

To create the Docker hosted repository and to install the Docker package, add a single class to the manifest file:

```puppet
include 'docker'
```

If you are using Ubuntu, all the required Kernel extensions are installed. To disable this feature, add the following code to the manifest file:

```puppet
class { 'docker':
  manage_kernel => false,
}
```

To configure package sources independently and disable automatically including sources, add the following code to the manifest file:

```puppet
class { 'docker':
  use_upstream_package_source => false,
}
```

The latest Docker [repositories](https://blog.docker.com/2015/07/new-apt-and-yum-repos/#comment-247448) are now the default repositories for version 5 and above. To use previous repositories, add the following code to the manifest file:

```puppet
class { 'docker':
  package_name => 'lxc-docker',
  package_source_location => 'https://get.docker.com/ubuntu',
  package_key_source => 'https://get.docker.com/gpg',
  package_key => '36A1D7869245C8950F966E92D8576A8BA88D21E',
  package_release => 'docker',
}
```

Docker provides a commercially supported version of the [Docker Engine](https://docs.docker.com/docker-trusted-registry/install/install-csengine/), called Docker CS. To install Docker DS, add the following code to the manifest file:

```puppet
class { 'docker':
  docker_cs => true,
}
```

For Red Hat Enterprise Linux (RHEL) based distributions, including Fedora, the docker module uses the upstream repositories. To continue using the distribution packages, add the following code to the manifest file:

```puppet
class { 'docker':
  use_upstream_package_source => false,
  package_name => 'docker',
}
```

By default, the Docker daemon binds to a unix socket at `/var/run/docker.sock`. To change this parameter and to update the binding parameter to a tcp socket, add the following code to the manifest file:

```puppet
class { 'docker':
  tcp_bind        => ['tcp://127.0.0.1:4243','tcp://10.0.0.1:4243'],
  socket_bind     => 'unix:///var/run/docker.sock',
  ip_forward      => true,
  iptables        => true,
  ip_masq         => true,
  bridge          => br0,
  fixed_cidr      => '10.20.1.0/24',
  default_gateway => '10.20.0.1',
}
```

If setting up TLS, upload the related files (such as CA certificate, server certificate, and key) and include their paths in the manifest file:

```puppet
class { 'docker':
  tcp_bind        => ['tcp://0.0.0.0:2376'],
  tls_enable      => true,
  tls_cacert      => '/etc/docker/tls/ca.pem',
  tls_cert        => '/etc/docker/tls/cert.pem',
  tls_key         => '/etc/docker/tls/key.pem',
}
```

Only the latest version of Docker supports Archlinux. To install a specific version of Docker, add the following code to the manifest file: 

```puppet
class { 'docker':
  version => '0.5.5',
}
```

To install a specific Docker rpm package, add the following code to the manifest file:

```puppet
class { 'docker' :
  manage_package              => true,
  use_upstream_package_source => false,
  package_name                => 'docker-engine'
  package_source              => 'https://get.docker.com/rpm/1.7.0/centos-6/RPMS/x86_64/docker-engine-1.7.0-1.el6.x86_64.rpm',
  prerequired_packages        => [ 'glibc.i686', 'glibc.x86_64', 'sqlite.i686', 'sqlite.x86_64', 'device-mapper', 'device-mapper-libs', 'device-mapper-event-libs', 'device-mapper-event' ]
}
```

To track the latest version of Docker, add the following code to the manifest file:

```puppet
class { 'docker':
  version => 'latest',
}
```

To allocate a dns server to the Docker daemon, add the following code to the manifest file:

```puppet
class { 'docker':
  dns => '8.8.8.8',
}
```

To add users to the Docker group, add the following array to the manifest file:

```puppet
class { 'docker':
  docker_users => ['user1', 'user2'],
}
```

To add daemon labels, add the following array to the manifest file:

```puppet
class { 'docker':
  labels => ['storage=ssd','stage=production'],
}
```

### Images

Each image name must be unique, otherwise the installation fails when a duplicate image name is detected. 

To install a Docker image, add the `docker::image` defined type to the manifest file:

```puppet
docker::image { 'base': }
```

The code above is equivalent to running the `docker pull base` command. However, it removes the default five minute timeout for execution. 

Takes an optional parameter for installing image tags that is the equivalent to running `docker pull -t="precise" ubuntu`:

```puppet
docker::image { 'ubuntu':
  docker_file => '/tmp/Dockerfile'
}
```

The above code adds an image from the listed Dockerfile. Including the `docker_file` parameter is equivalent to running the `docker build -t ubuntu - < /tmp/Dockerfile` command.

You can also specify an image from a Docker directory by including the `docker_dir` parameter in the manifest file instead of the `docker_file` parameter. This is the same as running the `docker build -t ubuntu /tmp/ubuntu_image` command.

```puppet
docker::image { 'ubuntu':
  docker_dir => '/tmp/ubuntu_image'
}
```

To rebuild an image, subscribe to external events such as Dockerfile changes by adding the following code to the manifest file:

```puppet
docker::image { 'ubuntu':
  docker_file => '/tmp/Dockerfile'
  subscribe => File['/tmp/Dockerfile'],
}

file { '/tmp/Dockerfile':
  ensure => file,
  source => 'puppet:///modules/someModule/Dockerfile',
}
```

To remove an image, add the following code to the manifest file:

```puppet
docker::image { 'base':
  ensure => 'absent'
}

docker::image { 'ubuntu':
  ensure    => 'absent',
  image_tag => 'precise'
}
```

To configure the `docker::images` class when using Hiera, add the following code to the manifest file:

```yaml
---
  classes:
    - docker::images

docker::images::images:
  ubuntu:
    image_tag: 'precise'
```


### Containers

To launch the containers, add the following code to the manifest file:

```puppet
docker::run { 'helloworld':
  image   => 'base',
  command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
}
```

This is the same as running the  `docker run -d base /bin/sh -c "while true; do echo hello world; sleep 1; done"` command which launches a Docker container managed by the local init system.

`run` includes a number of optional parameters: 

```puppet
docker::run { 'helloworld':
  image           => 'base',
  command         => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  ports           => ['4444', '4555'],
  expose          => ['4666', '4777'],
  links           => ['mysql:db'],
  net             => 'my-user-def-net',
  volumes         => ['/var/lib/couchdb', '/var/log'],
  volumes_from    => '6446ea52fbc9',
  memory_limit    => '10m', # (format: '<number><unit>', where unit = b, k, m or g)
  cpuset          => ['0', '3'],
  username        => 'example',
  hostname        => 'example.com',
  env             => ['FOO=BAR', 'FOO2=BAR2'],
  env_file        => ['/etc/foo', '/etc/bar'],
  dns             => ['8.8.8.8', '8.8.4.4'],
  restart_service => true,
  privileged      => false,
  pull_on_start   => false,
  before_stop     => 'echo "So Long, and Thanks for All the Fish"',
  before_start    => 'echo "Run this on the host before starting the Docker container"',
  after           => [ 'container_b', 'mysql' ],
  depends         => [ 'container_a', 'postgres' ],
  extra_parameters => [ '--restart=always' ],
}
```

You can specify the ports, expose, env, dns, and volumes values with a single string or an array.

To pull the image before it starts, specify the `pull_on_start` parameter.

To execute a command before the container stops, specify the `before_stop` parameter. 

Add the container name to the `after` parameter allows expressing containers that must be started before. This affects the generation of the `init.d/systemd` script.

Add container dependencies to the `depends` parameter. The container is started before this container and is stopped before the depended container. This affects the generation of the `init.d/systemd` script. Use the `depend_services` parameter to specify dependencies for generic services, not Docker related, that should be started before this container.

The `extra_parameters` parameter contains an array of command line arguments to pass to the `docker run` command. This parameter is useful for adding additional or experimental options that the docker module currently does not support.

By default, automatic restarting of the service on failure is enabled by the service file for systemd based systems. 

To use an image tag, append the tag name to the image name separated by a semicolon:

```puppet
docker::run { 'helloworld':
  image   => 'ubuntu:precise',
  command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
}
```

By default the generated init scripts remove the container (but not
any associated volumes) when the service is stopped or started. To modify this behaviour, add the following code to the manifest file:

```puppet
docker::run { 'helloworld':
  remove_container_on_start => true,
  remove_volume_on_start    => false,
  remove_container_on_stop  => true,
  remove_volume_on_stop     => false,
}
```

If using Hiera, you can configure the `docker::run_instance` class:

```yaml
---
  classes:
    - docker::run_instance

  docker::run_instance::instance:
    helloworld:
      image: 'ubuntu:precise'
      command: '/bin/sh -c "while true; do echo hello world; sleep 1; done"'
```

### Networks

Docker 1.9.x officially supports networks. To expose the `docker_network` type which is used to manage networks, add the following code to the manifest file:

```puppet
docker_network { 'my-net':
  ensure   => present,
  driver   => 'overlay',
  subnet   => '192.168.1.0/24',
  gateway  => '192.168.1.1',
  ip_range => '192.168.1.4/32',
}
```

The name value and the `ensure` parameter are required. If the `driver` value is not included, the default bridge is used. The Docker daemon must be configured for some networks and an example would be configuring the cluster store for the overlay network. 


To configure the cluster store, update the `docker` class in the manifest file:

```puppet
extra_parameters => '--cluster-store=<backend>://172.17.8.101:<port> --cluster-advertise=<interface>:2376'
```

If using Hiera, configure the `docker::networks` class in the manifest file:

```yaml
---
  classes:
    - docker::networks

docker::networks::networks:
  local-docker:
    ensure: 'present'
    subnet: '192.168.1.0/24'
    gateway: '192.168.1.1'
```

A defined network can be used on a `docker::run` resource with the `net` parameter.

### Compose


Docker Compose describes a set of containers in YAML format and runs a command to build and run those containers. Included in the module is the `docker_compose` type. This enables Puppet to run Compose and remediate any issues to ensure reality matches the model in your Compose file.

Before using the `docker_compose` type, the docker-compose utility must be installed. 

To install docker-commpose, add the following code to the manifest file:

```puppet
class {'docker::compose': 
  ensure => present,
}
```

This is a example of a Compose file:

```yaml
compose_test:
  image: ubuntu:14.04
  command: /bin/sh -c "while true; do echo hello world; sleep 1; done"
```

The compose file can be added to the machine you're running Puppet, using a `file`
resource or any other means.

To define a `docker_compose` resource pointing to the Compose file, add the following code to the manifest file:

```puppet
docker_compose { '/tmp/docker-compose.yml':
  ensure  => present,
}
```

Puppet automatically runs Compose, because the relevant Compose services aren't running. You can also include additional options, such as enabling experimental
features, as well as including scaling rules. 


The code below requests that two containers are running. Puppet runs Compose if the number of containers for a given service don't match the provided scale values.

```puppet
docker_compose { '/tmp/docker-compose.yml':
  ensure  => present,
  scale   => {
    'compose_test' => 2,
  },
  options => '--x-networking'
}
```
You can also give options to the ```docker-compose up``` command, such as ```--remove-orphans``, by using the ```up_args``` option.

If you are using a v3.2 compose file or above on a Docker Swarm cluster, you must use the `docker::stack` class. The file resource needs to be there before you run the stack command. To deploy the stack, add the following code to the manifest file: 

```puppet
 docker::stack { 'yourapp':
   ensure  => present,
   stack_name => 'yourapp',
   compose_file => '/tmp/docker-compose.yaml',
   require => [Class['docker'], File['/tmp/docker-compose.yaml']],
 }
 ```  
 
 To remove the stack set `ensure  => absent`

If you are using a compose file v3.2 or above on a Docker Swarm cluster you will have to use the 
`docker::stack` class. Like with older versions of Docker compose the file resource needs to be there 
before you run the stack command. Then to deploy the stack please see the below example.
```puppet
docker::stack { 'yourapp':
  ensure  => present,
  stack_name => 'yourapp',
  compose_file => '/tmp/docker-compose.yaml',
  require => [Class['docker'], File['/tmp/docker-compose.yaml']],
}
```  
To remove the stack set `ensure  => absent`

### Swarm mode

To natively manage a cluster of Docker Engines known as a swarm, Docker Engine 1.12 includes a swarm mode. 

To cluster your Docker engines, use one of the following Puppet resources:

* [Swarm manager](#Swarm-manager)
* [Swarm worker](#Swarm-worker)

#### Swarm manager 

To configure the swarm manager, add the following code to the manifest file:

```puppet
docker::swarm {'cluster_manager':
  init           => true,
  advertise_addr => '192.168.1.1',
  listen_addr    => '192.168.1.1',  
} 
```

For a multihomed server and to enable cluster communications between the node, include the ```advertise_addr``` and ```listen_addr``` parameters.

#### Swarm worker

To configure the swarm worker, add the following code to the manifest file:

```puppet
docker::swarm {'cluster_worker':
join           => true,
advertise_addr => '192.168.1.2',
listen_addr    => '192.168.1.2,
manager_ip     => '192.168.1.1',
token          => 'SWMTKN-1-2lw8bnr57qsu74d6iq2q1wr2wq2i334g7425dfr3zucimvh4bl-2vwn6gysbdj605l37c61iixie'
} 
```

To configure a worker node or a second manager, include the swarm manager IP address in the `manager_ip` parameter. To define the role of the node in the cluster, include the `token` parameter. When creating another swarm manager and a worker node, separate tokens are required. 

To remove a node from a cluster, add the following code to the manifest file:

```puppet
docker::swarm {'cluster_worker':
ensure => absent
}
```
### Docker services

Docker services create distributed applications across multiple swarm nodes. Each Docker service contains a set of containers which are replicated across the swarm.

To create a Docker service, add the following code to the manifest file:

```puppet
docker::services {'redis':
    create => true,   
    service_name => 'redis',
    image => 'redis:latest',
    publish => '6379:639',
    replicas => '5', 
    extra_params => ['--update-delay 1m', '--restart-window 30s']
  }
```

To base the service off an image, include the `image` parameter and include the `publish` parameter to expose the service ports. To set the amount of containers running in the service, include the `replicas` parameter. For information regarding the `extra_params` parameter, see `docker service create --help`.

To update the service, add the following code to the manifest file:

```puppet 
docker::services {'redis_update':
  create => false,
  update => true,
  service_name => 'redis',
  replicas => '3',
}
```

To update the service and not create a new service, include the the `update => true` parameter and the `create => false` parameter.

To scale a service, add the following code to the manifest file:

```puppet
docker::services {'redis_scale':
  create => false,
  scale => true,
  service_name => 'redis',
  replicas => '10', 
}
```

To scale the service and not create a new service, include the the `scale => true` parameter and the `create => false` parameter. In the above example, the service is scaled to 10. 

To remove a service, add the following code to the manifest file:

```puppet
docker::services {'redis':
  ensure => 'absent',
  service_name => 'redis',
}
```

To remove the service from a swarm, include the `ensure => absent` parameter and the `service_name` parameter.

### Private registries

If you do not specify a server, images are pushed and pulled from [index.docker.io](https://index.docker.io). To qualify your image name, you must have a private repository without authentication. 

To configure authentication for a private registry, add the following code to the manifest file:

```puppet
docker::registry { 'example.docker.io:5000':
  username => 'user',
  password => 'secret',
  email    => 'user@example.com',
}
```

If using hiera, configure the `docker::registry_auth` class:

```yaml
docker::registry_auth::registries:
  'example.docker.io:5000':
    username: 'user1'
    password: 'secret'
    email: 'user1@example.io'
  }
```

To log out of a registry, add the following code to the manifest file:

```puppet
docker::registry { 'example.docker.io:5000':
  ensure => 'absent',
}
```   

### Exec

Within the context of a running container, the docker module supports arbitrary commands:

```puppet
docker::exec { 'cron_allow_root':
  detach       => true,
  container    => 'mycontainer',
  command      => '/bin/echo root >> /usr/lib/cron/cron.allow',
  tty          => true,
  unless       => 'grep root /usr/lib/cron/cron.allow 2>/dev/null',
}
```
## Reference

### Parameters

#### `version`

The version of the package to install.

Defaults to `undefined`.

#### `ensure`

Passed to the docker package.

Defaults to `present`.

#### `prerequired_packages`

An array of additional packages that need to be installed to support docker. Defaults change depending on the operating system.

#### `docker_cs`

Specifies whether to use the Commercial Support (CS ) Docker packages.

Values `'true','false'`.

Defaults to `false`.

#### `tcp_bind`

The tcp socket to bind to. The format is tcp://127.0.0.1:4243

Defaults to `undefined`.

#### `tls_enable`

Specifies whether to enable TLS.

Values `'true','false'`.

Defaults to `false`.

#### `tls_verify`

Specifies whether to use TLS and verify the remote.

Values `'true','false'`.

Defaults to `true`.

#### `tls_cacert`

The directory for the TLS CA certificate.

Defaults to `'/etc/docker/ca.pem'`.

#### `tls_cert`

The directory for the TLS certificate file.

Defaults to `'/etc/docker/cert.pem'`.

#### `tls_key`

The directory for the TLS key file.

Defaults to `'/etc/docker/cert.key'`.

#### `ip_forward`

Specifies whether to enable IP forwarding on the Docker host.

Values `'true','false'`.

Defaults to `true`.

#### `iptables`

Specifies whether to enable Docker's addition of iptables rules.

Values `'true','false'`.

Defaults to `true`.

#### `ip_masq`

Specifies whether to enable IP masquerading for the bridge's IP range.

Values `'true','false'`.

Defaults to `true`.

#### `icc`

Enable the Docker unrestricted inter-container and the daemon host communication.

To disable, it requires `iptables=true`.

Defaults to undef. The Docker daemon default value is `true`.

#### `bip`

Specify docker's network bridge IP, in CIDR notation.

Defaults to `undefined`.

#### `mtu`

Docker network MTU.

Defaults to `undefined`.

#### `bridge`

Attach containers to a pre-existing network bridge. Use `none` to disable container networking.

Defaults to `undefined`.

#### `fixed_cidr`

IPv4 subnet for fixed IPs 10.20.0.0/16

Defaults to `undefined`.

#### `default_gateway`

IPv4 address of the container default gateway. This address must be part of the bridge subnet (which is defined by bridge).

Defaults to `undefined`.

#### `socket_bind`

The unix socket to bind to. 

Defaults to `unix:///var/run/docker.sock.`

#### `log_level`

Set the logging level.

Defaults to undef. Docker defaults to `info` if no value specified.

Valid values: `debug`, `info`, `warn`, `error`, `fatal`.

#### `log_driver`

Set the log driver.

Defaults to undef.

Docker default is `json-file`.

Valid values:

* `none`: disables logging for the container. Docker logs are not available with this driver.
* `json-file`: default logging driver for Docker that writes JSON messages to file.
* `syslog`: syslog logging driver for Docker that writes log messages to syslog.
* `journald`: journald logging driver for Docker that writes log messages to journald.
* `gelf`: Graylog Extended Log Format (GELF) logging driver for Docker that writes log messages to a GELF endpoint: Graylog or Logstash.
* `fluentd`: fluentd logging driver for Docker. that writes log messages to fluentd (forward input).
* `splunk`: Splunk logging driver for Docker that writes log messages to Splunk (HTTP Event Collector).

#### `log_opt`

Define the log driver option.

Defaults to undef.

Valid values:

* `none`: undef
* `json-file`: max-size=[0-9+][k|m|g] max-file=[0-9+]
* `syslog`: syslog-address=[tcp|udp]://host:port, syslog-address=unix://path, syslog-facility=daemon|kern|user|mail|auth, syslog|lpr|news|uucp|cron, authpriv|ftp, local0|local1|local2|local3, local4|local5|local6|local7, syslog-tag="some_tag"
* `journald`: undef
* `gelf`: gelf-address=udp://host:port, gelf-tag="some_tag"
* `fluentd`: fluentd-address=host:port, fluentd-tag={{.ID}} - short container id (12 characters), {{.FullID}} - full container id, {{.Name}} - container name
* `splunk`: splunk-token=<splunk_http_event_collector_token>, splunk-url=https://your_splunk_instance:8088|

#### `selinux_enabled`

Specifies whether to enable selinux support. SELinux supports the BTRFS storage driver.

Valid values are `true`, `false`.

Defaults to `false`.

#### `use_upstream_package_source`

Specifies whether to use the upstream package source.

Valid values are `true`, `false`.

If you run your own package mirror, set the value to `false`.

#### `pin_upstream_package_source`

Specifies whether to use the pin upstream package source. This option only effects apt-based distributions.  

Valid values are `true`, `false`.

Defaults to `true`.

Set to `false` to remove pinning on the upstream package repository.  See also `apt_source_pin_level`.

#### `apt_source_pin_level`

The level to pin your source package repository to. This only is relevent if you're on an apt-based system (Debian, Ubuntu, etc) and $use_upstream_package_source is set to `true`.  

To disable pinning, set the value to `false`. To ensure the apt preferences file `apt::source` uses to define pins is removed, set value to undef.

Defaults to `10`.

#### `package_source_location`

Specifies the location of the package source. 

For Debian, the value defaults to `http://get.docker.com/ubuntu`.

#### `service_state`

Specifies whether to start the docker daemon.

Defaults to `running`.

#### `service_enable`

Specifies whether the docker daemon starts up at boot.

Valid values are `true`, `false`.

Defaults to `true`.

#### `manage_service`

Specifies whether the service should be managed.

Valid values are `true`, `false'.

Defaults to `true'.

#### `root_dir`

Custom root directory for the containers.

Defaults to `undefined`.

#### `manage_kernel`

Specifies whether to install the Kernel required by docker.

Valid values are `true`, `false`.

Defaults to `true`.

#### `dns`

The custom dns server address.

Defaults to `undefined`.

#### `dns_search`

The custom dns search domains.

Defaults to `undefined`.

#### `socket_group`

Group ownership of the unix control socket.

Defaults to `undefined`.

#### `extra_parameters`

Extra parameters that should be passed to the docker daemon.

Defaults to `undefined`.

#### `shell_values`

The array of shell values to pass into the init script config files.

#### `proxy`

Defines the `http_proxy and https_proxy env` variables in `/etc/sysconfig/docker` (redhat/centos) or `/etc/default/docker` (debian).

#### `no_proxy`

Sets the `no_proxy` variable in `/etc/sysconfig/docker` (redhat/centos) or `/etc/default/docker` (debian).

#### `storage_driver`

Defines the storage driver to use.

Default is undef: let docker choose the correct one.

Valid values: `aufs`, `devicemapper`, `btrfs`, `overlay`, `overlay2`, `vfs`, and `zfs`.

#### `dm_basesize`

The size to use when creating the base device, which limits the size of images and containers.

Default value is `10G`.

#### `dm_fs`

The filesystem to use for the base image (xfs or ext4).

Defaults to `ext4`.

#### `dm_mkfsarg`

Specifies extra mkfs arguments to be used when creating the base device.

#### `dm_mountopt`

Specifies extra mount options used when mounting the thin devices.

#### `dm_blocksize`

A custom blocksize for the thin pool.

Default blocksize is `64K`.

Do not change this parameter after the lvm devices initialize.

#### `dm_loopdatasize`

Specifies the size to use when creating the loopback file for the "data" device which is used for the thin pool.

Default size is `100G`.

#### `dm_loopmetadatasize`

Specifies the size to use when creating the loopback file for the "metadata" device which is used for the thin pool.

Default size is `2G`.

#### `dm_datadev`

This is deprecated. Use `dm_thinpooldev`.

A custom blockdevice to use for data for the thin pool.

#### `dm_metadatadev`

This is deprecated. Use `dm_thinpooldev`.

A custom blockdevice to use for metadata for the thin pool.

#### `dm_thinpooldev`

Specifies a custom block storage device to use for the thin pool.

#### `dm_use_deferred_removal`

Enables the use of deferred device removal if libdm and the kernel driver support the mechanism.

#### `dm_use_deferred_deletion`

Enables the use of deferred device deletion if libdm and the kernel driver support the mechanism.

#### `dm_blkdiscard`

Enables the use of blkdiscard when removing devicemapper devices.

Valid values are `true`, `false`.

Defaults to `false`.

#### `dm_override_udev_sync_check`

Specifies whether to disable the devicemapper backend synchronizing with the udev device manager for the Linux kernel.

Valid values are `true`, `false`.

Defaults to `true`.

#### `manage_package`

Specifies whether to install or define the docker package. This is useful if you want to use your own package.

Valid values are `true`, `false`.

Defaults to `true`.

#### `package_name`

Specifies the custom package name.

Default is set on a per system basis in `docker::params`.

#### `service_name`

Specifies the custom service name.

Default is set on a per system basis in `docker::params`.

#### `docker_command`

Specifies a custom docker command name.

Default is set on a per system basis in `docker::params`.

#### `daemon_subcommand`

Specifies a subcommand for running docker as daemon.

Default is set on a per system basis in `docker::params`.

#### `docker_users`

Specifies an array of users to add to the docker group.

Default is `empty`.

#### `docker_group`

Specifies a string for the docker group.

Default is `OS and package specific`.

#### `daemon_environment_files`

Specifies additional environment files to add to the `service-overrides.conf` file. 

#### `repo_opt`

Specifies a string to pass as repository options. This is for RedHat.

#### `storage_devs`

A quoted, space-separated list of devices to be used.

#### `storage_vg`

The volume group to use for docker storage.

#### `storage_root_size`

The maximum size of the root filesystem.

#### `storage_data_size`

The desired size for the docker data LV.

#### `storage_min_data_size`

Specifies the minimum size of data volume, otherwise the pool creation fails.

#### `storage_chunk_size`

Controls the chunk size/block size of the thin pool.

#### `storage_growpart`

Enables resizing the partition table backing root volume group.

#### `storage_auto_extend_pool`

Enables automatic pool extension using lvm.

#### `storage_pool_autoextend_threshold`

Auto pool extension threshold (in % of pool size).

#### `storage_pool_autoextend_percent`

Extends the pool by the specified percentage when the threshold is passed.

## Limitations

This module supports:

* Debian 8.0
* Debian 9.0
* Ubuntu 14.04
* Ubuntu 16.04
* Centos 7.0

## Development

If you would like to contribute to this module, see the guidelines in [CONTRIBUTING.MD](https://github.com/puppetlabs/puppetlabs-docker/blob/master/CONTRIBUTING.md).