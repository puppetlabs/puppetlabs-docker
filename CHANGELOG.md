# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v3.13.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.13.0) (2020-12-14)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.12.1...v3.13.0)

### Added

- pdksync - \(feat\) - Bump Puppet boundary [\#687](https://github.com/puppetlabs/puppetlabs-docker/pull/687) ([daianamezdrea](https://github.com/daianamezdrea))
- Support multiple mirrors \#659 [\#669](https://github.com/puppetlabs/puppetlabs-docker/pull/669) ([TheLocehiliosan](https://github.com/TheLocehiliosan))

### Fixed

- Options to docker-compose should be an Array, not a String [\#695](https://github.com/puppetlabs/puppetlabs-docker/pull/695) ([adrianiurca](https://github.com/adrianiurca))
- fixing issue \#689 by setting HOME in docker command [\#692](https://github.com/puppetlabs/puppetlabs-docker/pull/692) ([sdinten](https://github.com/sdinten))
- \(MAINT\) Use docker-compose config instead file parsing [\#672](https://github.com/puppetlabs/puppetlabs-docker/pull/672) ([rbelnap](https://github.com/rbelnap))
- Fix array of additional flags [\#671](https://github.com/puppetlabs/puppetlabs-docker/pull/671) ([CAPSLOCK2000](https://github.com/CAPSLOCK2000))
- Test against OS family rather than name [\#667](https://github.com/puppetlabs/puppetlabs-docker/pull/667) ([bodgit](https://github.com/bodgit))

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- Ensure image digest checksum before starting [\#673](https://github.com/puppetlabs/puppetlabs-docker/pull/673) ([tmanninger](https://github.com/tmanninger))

## [v3.12.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.12.1) (2020-10-13)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.12.0...v3.12.1)

### Fixed

- Fix misplaced backslash in start template [\#666](https://github.com/puppetlabs/puppetlabs-docker/pull/666) ([optiz0r](https://github.com/optiz0r))

## [v3.12.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.12.0) (2020-09-24)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.11.0...v3.12.0)

### Added

- Add docker swarm join-tokens as facts [\#651](https://github.com/puppetlabs/puppetlabs-docker/pull/651) ([oschusler](https://github.com/oschusler))

### Fixed

- \(IAC-982\) - Remove inappropriate terminology [\#654](https://github.com/puppetlabs/puppetlabs-docker/pull/654) ([david22swan](https://github.com/david22swan))

## [v3.11.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.11.0) (2020-08-11)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.10.2...v3.11.0)

### Added

- Fix \#584: Deal with Arrays for the net list [\#647](https://github.com/puppetlabs/puppetlabs-docker/pull/647) ([MG2R](https://github.com/MG2R))
- pdksync - \(IAC-973\) - Update travis/appveyor to run on new default branch main [\#643](https://github.com/puppetlabs/puppetlabs-docker/pull/643) ([david22swan](https://github.com/david22swan))

## [v3.10.2](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.10.2) (2020-07-16)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.10.1...v3.10.2)

### Fixed

- \[MODULES-10734\] - improve params detection on docker::run [\#648](https://github.com/puppetlabs/puppetlabs-docker/pull/648) ([adrianiurca](https://github.com/adrianiurca))
- \(MODULES-10691\) - Add root\_dir in daemon.json [\#632](https://github.com/puppetlabs/puppetlabs-docker/pull/632) ([daianamezdrea](https://github.com/daianamezdrea))
- Fixing the fix 'Fix the docker\_compose options parameter position \#378' [\#631](https://github.com/puppetlabs/puppetlabs-docker/pull/631) ([awegmann](https://github.com/awegmann))
- Blocking ordering between non-Windows service stops [\#622](https://github.com/puppetlabs/puppetlabs-docker/pull/622) ([ALTinners](https://github.com/ALTinners))
- Allow all 3.x docker-compose minor versions [\#620](https://github.com/puppetlabs/puppetlabs-docker/pull/620) ([runejuhl](https://github.com/runejuhl))

## [v3.10.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.10.1) (2020-05-27)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.10.0...v3.10.1)

### Fixed

- Fix unreachable StartLimitBurst value in unit template [\#616](https://github.com/puppetlabs/puppetlabs-docker/pull/616) ([omeinderink](https://github.com/omeinderink))
- \(MODULES-9696\) remove docker\_home\_dirs fact [\#613](https://github.com/puppetlabs/puppetlabs-docker/pull/613) ([carabasdaniel](https://github.com/carabasdaniel))
- \[MODULES-10629\] Throw error when docker login fails [\#610](https://github.com/puppetlabs/puppetlabs-docker/pull/610) ([carabasdaniel](https://github.com/carabasdaniel))
- \(maint\) - facts fix for centos [\#608](https://github.com/puppetlabs/puppetlabs-docker/pull/608) ([david22swan](https://github.com/david22swan))
- major adjustments for current code style [\#607](https://github.com/puppetlabs/puppetlabs-docker/pull/607) ([crazymind1337](https://github.com/crazymind1337))

## [v3.10.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.10.0) (2020-04-23)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.9.1...v3.10.0)

### Added

- \[IAC-291\] Convert acceptance tests to Litmus [\#585](https://github.com/puppetlabs/puppetlabs-docker/pull/585) ([carabasdaniel](https://github.com/carabasdaniel))
- Updated: Add Docker service \(create, remote, scale\) tasks [\#582](https://github.com/puppetlabs/puppetlabs-docker/pull/582) ([Flask](https://github.com/Flask))
- Add after\_start and after\_stop options to docker::run define [\#580](https://github.com/puppetlabs/puppetlabs-docker/pull/580) ([jantman](https://github.com/jantman))
- Make docker::machine::url configurable [\#569](https://github.com/puppetlabs/puppetlabs-docker/pull/569) ([baurmatt](https://github.com/baurmatt))
- Let docker.service start docker services managed by puppetlabs/docker… [\#563](https://github.com/puppetlabs/puppetlabs-docker/pull/563) ([jhejl](https://github.com/jhejl))

### Fixed

- Enforce TLS1.2 on Windows; minor fixes for RH-based testing [\#603](https://github.com/puppetlabs/puppetlabs-docker/pull/603) ([carabasdaniel](https://github.com/carabasdaniel))
- \[MODULES-10628\] Update documentation for docker volume and set options as parameter [\#599](https://github.com/puppetlabs/puppetlabs-docker/pull/599) ([carabasdaniel](https://github.com/carabasdaniel))
- Allow module to work on SLES [\#591](https://github.com/puppetlabs/puppetlabs-docker/pull/591) ([npwalker](https://github.com/npwalker))
- \(maint\) Fix missing stubs in docker\_spec.rb [\#589](https://github.com/puppetlabs/puppetlabs-docker/pull/589) ([Filipovici-Andrei](https://github.com/Filipovici-Andrei))
- Add Hiera lookups for resources in init.pp [\#586](https://github.com/puppetlabs/puppetlabs-docker/pull/586) ([fe80](https://github.com/fe80))
- Use standardized quote type to help tests pass [\#566](https://github.com/puppetlabs/puppetlabs-docker/pull/566) ([DLeich](https://github.com/DLeich))
- Minimal changes to work with podman-docker [\#562](https://github.com/puppetlabs/puppetlabs-docker/pull/562) ([seriv](https://github.com/seriv))

## [v3.9.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.9.1) (2020-01-17)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.9.0...v3.9.1)

### Fixed

- \(maint\) fix dependencies of powershell to 4.0.0 [\#568](https://github.com/puppetlabs/puppetlabs-docker/pull/568) ([sheenaajay](https://github.com/sheenaajay))

## [v3.9.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.9.0) (2019-12-09)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.8.0...v3.9.0)

### Added

- Add option for RemainAfterExit [\#549](https://github.com/puppetlabs/puppetlabs-docker/pull/549) ([vdavidoff](https://github.com/vdavidoff))

### Fixed

- Fix error does not show when image:tag does not exists \(\#552\) [\#553](https://github.com/puppetlabs/puppetlabs-docker/pull/553) ([rafaelcarv](https://github.com/rafaelcarv))
- Allow defining the name of the docker-compose symlink [\#544](https://github.com/puppetlabs/puppetlabs-docker/pull/544) ([gtufte](https://github.com/gtufte))
- Clarify usage of docker\_stack type up\_args and fix link to docs [\#537](https://github.com/puppetlabs/puppetlabs-docker/pull/537) ([jacksgt](https://github.com/jacksgt))
- Move StartLimit\* options to \[Unit\], fix StartLimitIntervalSec [\#531](https://github.com/puppetlabs/puppetlabs-docker/pull/531) ([runejuhl](https://github.com/runejuhl))

## [v3.8.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.8.0) (2019-10-01)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.7.0-bna...v3.8.0)

### Added

- pdksync - Add support on Debian10 [\#525](https://github.com/puppetlabs/puppetlabs-docker/pull/525) ([lionce](https://github.com/lionce))
- Add new Docker Swarm Tasks \(node ls, rm, update; service scale\) [\#509](https://github.com/puppetlabs/puppetlabs-docker/pull/509) ([khaefeli](https://github.com/khaefeli))

### Fixed

- Fix multiple additional flags for docker\_network [\#523](https://github.com/puppetlabs/puppetlabs-docker/pull/523) ([lemrouch](https://github.com/lemrouch))
- :bug: Fix wrong service detach handling [\#520](https://github.com/puppetlabs/puppetlabs-docker/pull/520) ([khaefeli](https://github.com/khaefeli))
- Fixing error: [\#516](https://github.com/puppetlabs/puppetlabs-docker/pull/516) ([darshannnn](https://github.com/darshannnn))
- Fix aliased plugin names [\#514](https://github.com/puppetlabs/puppetlabs-docker/pull/514) ([koshatul](https://github.com/koshatul))

## [v3.7.0-bna](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.7.0-bna) (2019-08-08)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/e2.6...v3.7.0-bna)

## [e2.6](https://github.com/puppetlabs/puppetlabs-docker/tree/e2.6) (2019-07-26)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.7.0...e2.6)

## [v3.7.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.7.0) (2019-07-18)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.6.0...v3.7.0)

### Added

- Added option to override docker-compose download location [\#482](https://github.com/puppetlabs/puppetlabs-docker/pull/482) ([piquet90](https://github.com/piquet90))

## [v3.6.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.6.0) (2019-06-25)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.5.0...v3.6.0)

### Changed

- \(FM-8100\) Update minimum supported Puppet version to 5.5.10 [\#486](https://github.com/puppetlabs/puppetlabs-docker/pull/486) ([eimlav](https://github.com/eimlav))

### Added

- \(FM-8151\) Add Windows Server 2019 support [\#493](https://github.com/puppetlabs/puppetlabs-docker/pull/493) ([eimlav](https://github.com/eimlav))
- Allow bypassing curl package ensure if needed [\#477](https://github.com/puppetlabs/puppetlabs-docker/pull/477) ([esalberg](https://github.com/esalberg))
- Support for docker machine download and install [\#466](https://github.com/puppetlabs/puppetlabs-docker/pull/466) ([acurus-puppetmaster](https://github.com/acurus-puppetmaster))
- Add service\_provider parameter to docker::run [\#376](https://github.com/puppetlabs/puppetlabs-docker/pull/376) ([iamjamestl](https://github.com/iamjamestl))

### Fixed

- Tasks frozen string [\#499](https://github.com/puppetlabs/puppetlabs-docker/pull/499) ([khaefeli](https://github.com/khaefeli))
- Fix \#239 local\_user permission denied [\#497](https://github.com/puppetlabs/puppetlabs-docker/pull/497) ([thde](https://github.com/thde))
- \(MODULES-9193\) Revert part of MODULES-9177 [\#490](https://github.com/puppetlabs/puppetlabs-docker/pull/490) ([eimlav](https://github.com/eimlav))
- \(MODULES-9177\) Fix version validation regex [\#489](https://github.com/puppetlabs/puppetlabs-docker/pull/489) ([eimlav](https://github.com/eimlav))
- Fix publish flag being erroneously added to docker service commands [\#471](https://github.com/puppetlabs/puppetlabs-docker/pull/471) ([twistedduck](https://github.com/twistedduck))
- Fix container running check to work for windows hosts [\#470](https://github.com/puppetlabs/puppetlabs-docker/pull/470) ([florindragos](https://github.com/florindragos))
- Allow images tagged latest to update on each run [\#468](https://github.com/puppetlabs/puppetlabs-docker/pull/468) ([electrofelix](https://github.com/electrofelix))
- Fix docker::image to not run images [\#465](https://github.com/puppetlabs/puppetlabs-docker/pull/465) ([hugotanure](https://github.com/hugotanure))

# 3.5.0

Changes range for dependent modules

Use multiple networks in docker::run and docker::services

Fixes quotes with docker::services command

Publish multiple ports to docker::services

A full list of issues and PRs associated with this release can be found [here](https://github.com/puppetlabs/puppetlabs-docker/milestone/7?closed=1)

# 3.4.0

Introduces docker_stack type and provider

Fixes frozen string in docker swarm token task

Acceptance testing updates

Allow use of newer translate module

A full list of issues and PRs associated with this release can be found [here](https://github.com/puppetlabs/puppetlabs-docker/milestone/6?closed=1)


# Version 3.3.0

Pins apt repo to 500 to ensure packages are updated

Fixes issue in docker fact failing when docker is not started

Acceptance testing updates

Allows more recent version of the reboot module

A full list of issues and PRs associated with this release can be found [here](https://github.com/puppetlabs/puppetlabs-docker/milestone/5?closed=1)

# Version 3.2.0

Adds in support for Puppet 6

Containers will be restared due to script changes in [PR #367](https://github.com/puppetlabs/puppetlabs-docker/pull/367)

A full list of issues and PRs associated with this release can be found [here](https://github.com/puppetlabs/puppetlabs-docker/milestone/4?closed=1)

# Version 3.1.0

Adding in the following faetures/functionality

- Docker Stack support on Windows.

# Version 3.0.0

Various fixes for github issues
- 206
- 226
- 241
- 280
- 281
- 287
- 289
- 294
- 303
- 312
- 314

Adding in the following features/functionality

-Support for multiple compose files.

A full list of issues and PRs associated with this release can be found [here](https://github.com/puppetlabs/puppetlabs-docker/issues?q=is%3Aissue+milestone%3AV3.0.0+is%3Aclosed)


# Version 2.0.0

Various fixes for github issues
- 193
- 197
- 198
- 203
- 207
- 208
- 209
- 211
- 212
- 213
- 215
- 216
- 217
- 218
- 223
- 224
- 225
- 228
- 229
- 230
- 232
- 234
- 237
- 243
- 245
- 255
- 256
- 259

Adding in the following features/functionality

- Ability to define swarm clusters in Hiera.
- Support docker compose file V2.3.
- Support refresh only flag.
- Support for Docker healthcheck and unhealthy container restart.
- Support for Docker on Windows:
    - Add docker ee support for windows server 2016.
    - Docker image on Windows.
    - Docker run on Windows.
    - Docker compose on Windows.
    - Docker swarm on Windows.
    - Add docker exec functionality for docker on windows.
    - Add storage driver for Windows.  

A full list of issues and PRs associated with this release can be found [here](https://github.com/puppetlabs/puppetlabs-docker/milestone/2?closed=1)


# Version 1.1.0

Various fixes for Github issues
- 183
- 173
- 173
- 167
- 163
- 161

Adding in the following features/functionality

- IPv6 support
- Define type for docker plugins

A full list of issues and PRs associated with this release can be found [here](https://github.com/puppetlabs/puppetlabs-docker/milestone/1?closed=1)


# Version 1.0.5

Various fixes for Github issues
- 98
- 104
- 115
- 122
- 124

Adding in the following features/functionality

- Removed all unsupported OS related code from module
- Removed EPEL dependency
- Added http support in compose proxy
- Added in rubocop support and i18 gem support
- Type and provider for docker volumes
- Update apt module to latest
- Added in support for a registry mirror
- Facts for docker version and docker info
- Fixes for $pass_hash undef
- Fixed typo in param.pp
- Replaced deprecated stblib functions with data types

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
