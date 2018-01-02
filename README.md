[![Build Status](https://travis-ci.org/puppetlabs/puppetlabs-docker.svg?branch=master)](https://travis-ci.org/puppetlabs/puppetlabs-docker)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppetlabs/docker.svg)](https://forge.puppetlabs.com/puppetlabs/docker)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/puppetlabs/docker.svg)](https://forge.puppetlabs.com/puppetlabs/docker)
[![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/puppetlabs/docker.svg)](https://forge.puppetlabs.com/puppetlabs/docker)


# Docker

#### Table of Contents

1. [Description](#description)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

The Puppet docker module installs, configures, and manages [Docker](https://github.com/docker/docker) from the [Docker repository](https://docs.docker.com/installation/). It supports the latest [Docker CE (Community Edition)](https://www.docker.com/community-edition) as well legacy releases.

With new naming convention of the Docker packages, this module now differentiates between by prefacing any params referring to the release with `_ce` or `_engine`. There are examples of this through the README.

## Description

This module installs, configures, and manages [Docker](https://github.com/docker/docker).

* Debian 8.0
* Debian 9.0
* Ubuntu 14.04
* Ubuntu 16.04
* Centos 7.0

## Usage

To create the Docker hosted repository and install the Docker package, add a single class to the manifest file:

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

The latest Docker [repositories](https://docs.docker.com/engine/installation/linux/docker-ce/debian/#set-up-the-repository) are now the default repositories for version 17.06 and above. If you are using a version prior to this, the old repositories will still be configured based on the version number passed into the module.

The following example will ensure the modules configures the latest repositories

```puppet
class { 'docker':
  version => '17.09.0~ce-0~debian',
}
```

Using a version prior to 17.06 will configure and install from the old repositories

```puppet
class { 'docker':
  version => '1.12.0-0~wheezy',
}
```

Docker provides a enterprise addition of the [Docker Engine](https://www.docker.com/enterprise-edition), called Docker EE. To install Docker EE on Debian systems, add the following code to the manifest file:

```puppet
class { 'docker':
  docker_ee => true,
  docker_ee_source_location => 'https://<docker_ee_repo_url',
  docker_ee_key_source => 'https://<docker_ee_key_source_url',
  docker_ee_key_id => '<key id>',
}
```

To install install Docker EE on RHEL/CentOS:

```puppet
class { 'docker':
  docker_ee => true,
  docker_ee_source_location => 'https://<docker_ee_repo_url',
  docker_ee_key_source => 'https://<docker_ee_key_source_url',
}
```


For Red Hat Enterprise Linux (RHEL) based distributions, including Fedora, the docker module uses the upstream repositories. To continue using the legacy distribution packages in the CentOS Extras repo, add the following code to the manifest file:

```puppet
class { 'docker':
  use_upstream_package_source => false,
  service_overrides_template  => false,
  docker_ce_package_name      => 'docker',
}
```

To use the CE packages

```puppet
class { 'docker':
  use_upstream_package_source => false,
  package_ce_name => 'docker-ce',
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

To specify which Docker rpm package to install, add the following code to the manifest file:

```puppet
class { 'docker' :
  manage_package              => true,
  use_upstream_package_source => false,
  package_engine_name         => 'docker-engine'
  package_source_location     => 'https://get.docker.com/rpm/1.7.0/centos-6/RPMS/x86_64/docker-engine-1.7.0-1.el6.x86_64.rpm',
  prerequired_packages        => [ 'glibc.i686', 'glibc.x86_64', 'sqlite.i686', 'sqlite.x86_64', 'device-mapper', 'device-mapper-libs', 'device-mapper-event-libs', 'device-mapper-event' ]
}
```

To track the latest version of Docker, add the following code to the manifest file:

```puppet
class { 'docker':
  version => 'latest',
}
```

To install docker from a test or edge channel, add the following code to the manifest file:

```puppet
class { 'docker':
  docker_ce_channel => 'test'
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

Each image name must be unique, otherwise the installation fails when a duplicate name is detected.

To install a Docker image, add the `docker::image` defined type to the manifest file:

```puppet
docker::image { 'base': }
```

The code above is equivalent to running the `docker pull base` command. However, it removes the default five minute execution timeout.

To include an optional parameter for installing image tags that is the equivalent to running `docker pull -t="precise" ubuntu`, add the following code to the manifest file:

```puppet
docker::image { 'ubuntu':
  image_tag => 'precise'
}
```

Including the `docker_file` parameter is equivalent to running the `docker build -t ubuntu - < /tmp/Dockerfile` command. To add or build an image from a dockerfile that includes the `docker_file` parameter, add the following code to the manifest file:

```puppet
docker::image { 'ubuntu':
  docker_file => '/tmp/Dockerfile'
}
```

Including the `docker_dir` parameter is equivalent to running the `docker build -t ubuntu /tmp/ubuntu_image` command. To add or build an image from a dockerfile that includes the `docker_dir` parameter, add the following code to the manifest file:

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

To launch containers, add the following code to the manifest file:

```puppet
docker::run { 'helloworld':
  image   => 'base',
  command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
}
```

This is equivalent to running the  `docker run -d base /bin/sh -c "while true; do echo hello world; sleep 1; done"` command to launch a Docker container managed by the local init system.

`run` includes a number of optional parameters:

```puppet
docker::run { 'helloworld':
  image            => 'base',
  command          => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  ports            => ['4444', '4555'],
  expose           => ['4666', '4777'],
  links            => ['mysql:db'],
  net              => 'my-user-def-net',
  volumes          => ['/var/lib/couchdb', '/var/log'],
  volumes_from     => '6446ea52fbc9',
  memory_limit     => '10m', # (format: '<number><unit>', where unit = b, k, m or g)
  cpuset           => ['0', '3'],
  username         => 'example',
  hostname         => 'example.com',
  env              => ['FOO=BAR', 'FOO2=BAR2'],
  env_file         => ['/etc/foo', '/etc/bar'],
  dns              => ['8.8.8.8', '8.8.4.4'],
  restart_service  => true,
  privileged       => false,
  pull_on_start    => false,
  before_stop      => 'echo "So Long, and Thanks for All the Fish"',
  before_start     => 'echo "Run this on the host before starting the Docker container"',
  after            => [ 'container_b', 'mysql' ],
  depends          => [ 'container_a', 'postgres' ],
  extra_parameters => [ '--restart=always' ],
}
```

You can specify the ports, expose, env, dns, and volumes values with a single string or an array.

To pull the image before it starts, specify the `pull_on_start` parameter.

To execute a command before the container stops, specify the `before_stop` parameter.

Add the container name to the `after` parameter to specify which containers start first. This affects the generation of the `init.d/systemd` script.

Add container dependencies to the `depends` parameter. The container starts before this container and stops before the depended container. This affects the generation of the `init.d/systemd` script. Use the `depend_services` parameter to specify dependencies for generic services, which are not Docker related, that start before this container.

The `extra_parameters` parameter contains an array of command line arguments to pass to the `docker run` command. This parameter is useful for adding additional or experimental options that the docker module currently does not support.

By default, automatic restarting of the service on failure is enabled by the service file for systemd based systems.

To use an image tag, add the following code to the manifest file:

```puppet
docker::run { 'helloworld':
  image   => 'ubuntu:precise',
  command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
}
```

By default, when the service is stopped or started the generated init scripts remove the container, but not the associated volumes. To change this behaviour, add the following code to the manifest file:

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

To remove a running container, add the following code to the manifest file. This will also remove the systemd service file associated with the container.

'''puppet
docker::run { 'helloworld':
  ensure => absent,
}
'''

### Networks

Docker 1.9.x officially supports networks. To expose the `docker_network` type, which is used to manage networks, add the following code to the manifest file:

```puppet
docker_network { 'my-net':
  ensure   => present,
  driver   => 'overlay',
  subnet   => '192.168.1.0/24',
  gateway  => '192.168.1.1',
  ip_range => '192.168.1.4/32',
}
```

The name value and the `ensure` parameter are required. If you do not include the `driver` value, the default bridge is used. The Docker daemon must be configured for some networks and an example would be configuring the cluster store for the overlay network.

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

Docker Compose describes a set of containers in YAML format and runs a command to build and run those containers. Included in the docker module is the `docker_compose` type. This enables Puppet to run Compose and remediate any issues to ensure reality matches the model in your Compose file.

You must install the Docker Compose utility, before you use the `docker_compose` type.

To install Docker Compose, add the following code to the manifest file:

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

Specify the `file` resource to add a Compose file to the machine you have Puppet running on. To define a `docker_compose` resource pointing to the Compose file, add the following code to the manifest file:

```puppet
docker_compose { '/tmp/docker-compose.yml':
  ensure  => present,
}
```

Puppet automatically runs Compose, because the relevant Compose services aren't running. You can include additional options, such as enabling experimental features, as well as including scaling rules.

In the example below, Puppet runs Compose when the number of containers specified for a service don't match the scale values.

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

If you are using a v3.2 compose file or above on a Docker Swarm cluster, you must use the `docker::stack` class. Include the file resource before you run the stack command.

To deploy the stack, add the following code to the manifest file:

```puppet
 docker::stack { 'yourapp':
   ensure  => present,
   stack_name => 'yourapp',
   compose_file => '/tmp/docker-compose.yaml',
   require => [Class['docker'], File['/tmp/docker-compose.yaml']],
}
```

To remove the stack set `ensure  => absent`.

If you are using a compose file v3.2 or above on a Docker Swarm cluster, include the `docker::stack` class. Like with older versions of Docker, compose the file resource needs before you run the stack command. To deploy the stack, add the following code to the manifest file.

```puppet
docker::stack { 'yourapp':
  ensure  => present,
  stack_name => 'yourapp',
  compose_file => '/tmp/docker-compose.yaml',
  require => [Class['docker'], File['/tmp/docker-compose.yaml']],
}
```
To remove the stack, set `ensure  => absent`.

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

To update a service without creating a new one, include the the `update => true` parameter and the `create => false` parameter.

To scale a service, add the following code to the manifest file:

```puppet
docker::services {'redis_scale':
  create => false,
  scale => true,
  service_name => 'redis',
  replicas => '10',
}
```

To scale the service without creating a new one, include the the `scale => true` parameter and the `create => false` parameter. In the example above, the service is scaled to 10.

To remove a service, add the following code to the manifest file:

```puppet
docker::services {'redis':
  create => false,
  ensure => 'absent',
  service_name => 'redis',
}
```

To remove the service from a swarm, include the `ensure => absent` parameter and the `service_name` parameter.

### Private registries

If a server is not specified, images are pushed and pulled from [index.docker.io](https://index.docker.io). To qualify your image name, create a private repository without authentication.

To configure authentication for a private registry, add the following code to the manifest file , depending on what version of Docker you are running. If you are using Docker V1.10 or earlier add the following code to the manifest file ensuring that you specify the docker version:

```puppet
docker::registry { 'example.docker.io:5000':
  username => 'user',
  password => 'secret',
  email    => 'user@example.com',
  version  => '<docker_version>'
}
```

If using hiera, configure the `docker::registry_auth` class:

```yaml
docker::registry_auth::registries:
  'example.docker.io:5000':
    username: 'user1'
    password: 'secret'
    email: 'user1@example.io'
    version: '<docker_version>'
  }
```

If using Docker V1.11 or later the docker login e-mail flag has been deprecated [docker_change_log](https://docs.docker.com/release-notes/docker-engine/#1110-2016-04-13). Add the following code to the manifest file:

'''puppet
docker::registry { 'example.docker.io:5000'}
  username => 'user',
  password => 'secret',
}
''

If using hiera, configure the 'docker::registry_auth' class:

'''yaml
docker::registry_auth::registries:
  'example.docker.io:5000':
    username: 'user1'
    password: 'secret'
  }
'''

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

An array of packages that are required to support Docker.

#### `docker_cs`

Specifies whether to use the Commercial Support (CS) Docker packages.

Values `'true','false'`.

Defaults to `false`.

#### `tcp_bind`

The tcp socket to bind to. The format is tcp://127.0.0.1:4243.

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

Defaults to undef. The default value for the Docker daemon is `true`.

#### `bip`

Specifies the Docker network bridge IP in CIDR notation.

Defaults to `undefined`.

#### `mtu`

Docker network MTU.

Defaults to `undefined`.

#### `bridge`

Attach containers to a pre-existing network bridge. To disable container networking, include `none`.

Defaults to `undefined`.

#### `fixed_cidr`

IPv4 subnet for fixed IPs 10.20.0.0/16.

Defaults to `undefined`.

#### `default_gateway`

IPv4 address for the container default gateway. This address must be part of the bridge subnet (which is defined by bridge).

Defaults to `undefined`.

#### `socket_bind`

The unix socket to bind to.

Defaults to `unix:///var/run/docker.sock.`

#### `log_level`

Sets the logging level.

Defaults to undef. If no value is specified, Docker defaults to `info`.

Valid values: `debug`, `info`, `warn`, `error`, and `fatal`.

#### `log_driver`

Sets the log driver.

Defaults to undef.

Docker default is `json-file`.

Valid values:

* `none`: disables logging for the container. Docker logs are not available with this driver.
* `json-file`: the default Docker logging driver that writes JSON messages to file.
* `syslog`: syslog logging driver that writes log messages to syslog.
* `journald`: journald logging driver that writes log messages to journald.
* `gelf`: Graylog Extended Log Format (GELF) logging driver that writes log messages to a GELF endpoint: Graylog or Logstash.
* `fluentd`: fluentd logging driver that writes log messages to fluentd (forward input).
* `splunk`: Splunk logging driver that writes log messages to Splunk (HTTP Event Collector).

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

When you run your own package mirror, set the value to `false`.

#### `pin_upstream_package_source`

Specifies whether to use the pin upstream package source. This option relates to apt-based distributions.

Valid values are `true`, `false`.

Defaults to `true`.

Set to `false` to remove pinning on the upstream package repository. See also `apt_source_pin_level`.

#### `apt_source_pin_level`

The level to pin your source package repository to. This relates to an apt-based system (such as Debian, Ubuntu, etc). Include $use_upstream_package_source and set the value to `true`.

To disable pinning, set the value to `false`.

Defaults to `10`.

#### `package_source_location`

Specifies the location of the package source.

For Debian, the value defaults to `http://get.docker.com/ubuntu`.

#### `service_state`

Specifies whether to start the Docker daemon.

Defaults to `running`.

#### `service_enable`

Specifies whether the Docker daemon starts up at boot.

Valid values are `true`, `false`.

Defaults to `true`.

#### `manage_service`

Specifies whether the service should be managed.

Valid values are `true`, `false'.

Defaults to `true'.

#### `root_dir`

The custom root directory for the containers.

Defaults to `undefined`.

#### `manage_kernel`

Specifies whether to install the Kernel required by Docker.

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

Extra parameters that should be passed to the Docker daemon.

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

Specifies the size to use when creating the loopback file for the data device which is used for the thin pool.

Default size is `100G`.

#### `dm_loopmetadatasize`

Specifies the size to use when creating the loopback file for the metadata device which is used for the thin pool.

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

### Tasks

The docker module has an example task that allows a user to initialize, join and leave a swarm.

```puppet
bolt task run docker::swarm_init listen_addr=172.17.10.101 adverstise_addr=172.17.10.101 ---nodes swarm-master --user <user> --password <password> --modulepath <module_path>

docker swarm init --advertise-addr=172.17.10.101 --listen-addr=172.17.10.101
Swarm initialized: current node (w8syk0g286vd7d9kwzt7jl44z) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-317gw63odq6w1foaw0xkibzqy34lga55aa5nbjlqekcrhg8utl-08vrg0913zken8h9vfo4t6k0t 172.17.10.101:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.


Ran on 1 node in 4.04 seconds
```

```puppet
bolt task run docker::swarm_token node_role=worker ---nodes swarm-master --user <user> --password <password> --modulepath <module_path>

SWMTKN-1-317gw63odq6w1foaw0xkibzqy34lga55aa5nbjlqekcrhg8utl-08vrg0913zken8h9vfo4t6k0t


Ran on 1 node in 4.02 seconds

```
```puppet
bolt task run docker::swarm_join listen_addr=172.17.10.102 adverstise_addr=172.17.10.102 token=<swarm_token> manager_ip=172.17.10.101:2377 --nodes swarm-02 --user root --password puppet --modulepath /tmp/modules


This node joined a swarm as a worker.


Ran on 1 node in 4.68 seconds
```
```puppet
bolt task run docker::swarm_leave --nodes swarm-02 --user root --password puppet --modulepath --modulepath <module_path>

Node left the swarm.


Ran on 1 node in 6.16 seconds
```




For further explanation please refer to the[PE documentation](https://puppet.com/docs/pe/2017.3/orchestrator/running_tasks.html) or [Bolt documentation](https://puppet.com/docs/bolt/latest/bolt.html) on how to execute a task.

## Limitations

This module supports:

* Debian 8.0
* Debian 9.0
* Ubuntu 14.04
* Ubuntu 16.04
* Centos 7.0

## Development

If you would like to contribute to this module, see the guidelines in [CONTRIBUTING.MD](https://github.com/puppetlabs/puppetlabs-docker/blob/master/CONTRIBUTING.md).
