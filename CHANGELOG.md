# Version 1.0.5
Various fixes for github issues

 - 124
 - 98
 - 73
 - 38
 - 14

Adding in the following fetures/functionality:

 - Adding resource type and provider for docker_volumes
 - Fixing docker registry $pass_hash condition and allowing $server param to contain slashes
 - Remove docker_cs param
 - Spec test updates
 - Add facts from docker version and info
 - Adding registry mirror flag for docker daemon
 - Removing deprecated supported Operating systems
 - Fixing systemd escaping
 - Add docker::compose accepting http proxy
 - Allow deactivation of service_config management
 - Fixingtypedef of storage_config , service_config and overides template
 - Replacing variant Tuple with Array[String]
 - updating apt module to the latest version
 - Replaced validate functions with datatypes and assert_type function.

# Version 1.0.4

Correcting changelog


# Version 1.0.3
Various fixes for Github issues
 - 33
 - 68
 - 74
 - 77
 - 84

Adding in the following features/functionality:

 - Add tasks to update existing service
 - Backwards compatible TMPDIR
 - Optional GPG check on repos
 - Force pull on image tag 'latest'
 - Add support for overlay2.override_kernel_check setting
 - Add docker network fact
 - Add pw hash for registry login idompodency
 - Additional flags for creating a network
 - Fixing incorrect repo url for redhat

# Version 1.0.2
Various fixes for Github issues
 - 9
 - 11
 - 15
 - 21
Add tasks support for Docker Swarm

# Version 1.0.1
Updated metadata and CHANGELOG

# Version 1.0.0
Forked for garethr/docker v5.3.0
Added support for:
- Docker services within a swarm cluster
- Swarm mode
- Docker secrets
