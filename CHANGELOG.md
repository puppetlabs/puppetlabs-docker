<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v9.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v9.1.0) - 2023-07-19

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v9.0.1...v9.1.0)

### Added

- CONT-568 : Adding deferred function for password [#918](https://github.com/puppetlabs/puppetlabs-docker/pull/918) ([malikparvez](https://github.com/malikparvez))

## [v9.0.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v9.0.1) - 2023-07-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v8.0.0...v9.0.1)

### Fixed

- (CONT-1196) - Remove deprecated function merge [#935](https://github.com/puppetlabs/puppetlabs-docker/pull/935) ([Ramesh7](https://github.com/Ramesh7))

## [v8.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v8.0.0) - 2023-07-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v7.0.0...v8.0.0)

### Added

- (CONT-1121) - Add support for CentOS 8 [#926](https://github.com/puppetlabs/puppetlabs-docker/pull/926) ([jordanbreen28](https://github.com/jordanbreen28))

### Changed
- pdksync - (MAINT) - Require Stdlib 9.x [#921](https://github.com/puppetlabs/puppetlabs-docker/pull/921) ([LukasAud](https://github.com/LukasAud))

## [v7.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v7.0.0) - 2023-05-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v6.1.0...v7.0.0)

### Changed
- (CONT-776) - Add Puppet 8/Drop Puppet 6 [#910](https://github.com/puppetlabs/puppetlabs-docker/pull/910) ([jordanbreen28](https://github.com/jordanbreen28))

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v6.1.0) - 2023-04-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v6.0.2...v6.1.0)

### Added

- (CONT-351) Syntax update [#901](https://github.com/puppetlabs/puppetlabs-docker/pull/901) ([LukasAud](https://github.com/LukasAud))

### Fixed

- Fix `docker` fact with recent version of docker [#897](https://github.com/puppetlabs/puppetlabs-docker/pull/897) ([smortex](https://github.com/smortex))
- Use puppet yaml helper to workaround psych >4 breaking changes  [#877](https://github.com/puppetlabs/puppetlabs-docker/pull/877) ([gfargeas](https://github.com/gfargeas))

## [v6.0.2](https://github.com/puppetlabs/puppetlabs-docker/tree/v6.0.2) - 2022-12-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v6.0.1...v6.0.2)

### Fixed

- (CONT-24) docker_stack always redoploying [#878](https://github.com/puppetlabs/puppetlabs-docker/pull/878) ([david22swan](https://github.com/david22swan))

## [v6.0.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v6.0.1) - 2022-11-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v6.0.0...v6.0.1)

### Fixed

- Revert "(maint) Hardening manifests and tasks" [#875](https://github.com/puppetlabs/puppetlabs-docker/pull/875) ([pmcmaw](https://github.com/pmcmaw))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v6.0.0) - 2022-11-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v5.1.0...v6.0.0)

### Changed
- (CONT-263) Bumping required puppet version [#871](https://github.com/puppetlabs/puppetlabs-docker/pull/871) ([LukasAud](https://github.com/LukasAud))
- docker_run_flags: Shellescape any provided values [#869](https://github.com/puppetlabs/puppetlabs-docker/pull/869) ([LukasAud](https://github.com/LukasAud))
- (maint) Hardening manifests and tasks [#863](https://github.com/puppetlabs/puppetlabs-docker/pull/863) ([LukasAud](https://github.com/LukasAud))

## [v5.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v5.1.0) - 2022-10-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v5.0.0...v5.1.0)

### Added

- Add missing extra_systemd_parameters values to docker-run.erb [#851](https://github.com/puppetlabs/puppetlabs-docker/pull/851) ([cbowman0](https://github.com/cbowman0))

### Fixed

- pdksync - (CONT-130) Dropping Support for Debian 9 [#859](https://github.com/puppetlabs/puppetlabs-docker/pull/859) ([jordanbreen28](https://github.com/jordanbreen28))
- Change `stop_wait_time` value to match Docker default [#858](https://github.com/puppetlabs/puppetlabs-docker/pull/858) ([sebcdri](https://github.com/sebcdri))

## [v5.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v5.0.0) - 2022-08-19

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.4.0...v5.0.0)

### Added

- pdksync - (GH-cat-11) Certify Support for Ubuntu 22.04 [#850](https://github.com/puppetlabs/puppetlabs-docker/pull/850) ([david22swan](https://github.com/david22swan))
- adding optional variable for package_key_check_source to RedHat [#846](https://github.com/puppetlabs/puppetlabs-docker/pull/846) ([STaegtmeier](https://github.com/STaegtmeier))

### Changed
- Remove log_driver limitations [#792](https://github.com/puppetlabs/puppetlabs-docker/pull/792) ([timdeluxe](https://github.com/timdeluxe))

## [v4.4.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.4.0) - 2022-06-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.3.0...v4.4.0)

### Added

- Update Docker Compose to handle symbols [#834](https://github.com/puppetlabs/puppetlabs-docker/pull/834) ([sili72](https://github.com/sili72))

### Fixed

- Avoid empty array to -net parameter [#837](https://github.com/puppetlabs/puppetlabs-docker/pull/837) ([chelnak](https://github.com/chelnak))
- (GH-785) Fix duplicate stack matching [#836](https://github.com/puppetlabs/puppetlabs-docker/pull/836) ([chelnak](https://github.com/chelnak))
- Fix docker-compose, network and volumes not applying on 1st run, fix other idempotency [#833](https://github.com/puppetlabs/puppetlabs-docker/pull/833) ([canihavethisone](https://github.com/canihavethisone))
- Fixed docker facts to check for active swarm clusters before running docker swarm sub-commands. [#817](https://github.com/puppetlabs/puppetlabs-docker/pull/817) ([nmaludy](https://github.com/nmaludy))

## [v4.3.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.3.0) - 2022-05-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.2.1...v4.3.0)

### Added

- Add tmpdir option to docker_compose [#823](https://github.com/puppetlabs/puppetlabs-docker/pull/823) ([canihavethisone](https://github.com/canihavethisone))
- Support different Architectures (like `aarch64`) when installing Compose [#812](https://github.com/puppetlabs/puppetlabs-docker/pull/812) ([mpdude](https://github.com/mpdude))

### Fixed

- Only install docker-ce-cli with docker-ce [#827](https://github.com/puppetlabs/puppetlabs-docker/pull/827) ([vchepkov](https://github.com/vchepkov))
- remove some legacy facts [#802](https://github.com/puppetlabs/puppetlabs-docker/pull/802) ([traylenator](https://github.com/traylenator))
- Fix missing comma in docker::image example [#787](https://github.com/puppetlabs/puppetlabs-docker/pull/787) ([Vincevrp](https://github.com/Vincevrp))
- allow docker::networks::networks param to be undef [#783](https://github.com/puppetlabs/puppetlabs-docker/pull/783) ([jhoblitt](https://github.com/jhoblitt))

## [v4.2.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.2.1) - 2022-04-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.2.0...v4.2.1)

### Fixed

- Fix permission denied issue introduced in v4.2.0 [#820](https://github.com/puppetlabs/puppetlabs-docker/pull/820) ([chelnak](https://github.com/chelnak))

## [v4.2.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.2.0) - 2022-04-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.1.2...v4.2.0)

### Added

- pdksync - (FM-8922) - Add Support for Windows 2022 [#801](https://github.com/puppetlabs/puppetlabs-docker/pull/801) ([david22swan](https://github.com/david22swan))
- (IAC-1729) Add Support for Debian 11 [#799](https://github.com/puppetlabs/puppetlabs-docker/pull/799) ([david22swan](https://github.com/david22swan))

### Fixed

- pdksync - (GH-iac-334) Remove Support for Ubuntu 14.04/16.04 [#807](https://github.com/puppetlabs/puppetlabs-docker/pull/807) ([david22swan](https://github.com/david22swan))
- Fix idempotency when using scaling with docker-compose [#805](https://github.com/puppetlabs/puppetlabs-docker/pull/805) ([canihavethisone](https://github.com/canihavethisone))
- Make RedHat version check respect acknowledge_unsupported_os [#788](https://github.com/puppetlabs/puppetlabs-docker/pull/788) ([PolaricEntropy](https://github.com/PolaricEntropy))

## [v4.1.2](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.1.2) - 2021-09-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.1.1...v4.1.2)

### Fixed

- pdksync - (IAC-1598) - Remove Support for Debian 8 [#775](https://github.com/puppetlabs/puppetlabs-docker/pull/775) ([david22swan](https://github.com/david22swan))
- Prefer timeout to time_limit for Facter::Core::Execution [#774](https://github.com/puppetlabs/puppetlabs-docker/pull/774) ([smortex](https://github.com/smortex))
- Fix facts gathering [#773](https://github.com/puppetlabs/puppetlabs-docker/pull/773) ([smortex](https://github.com/smortex))

## [v4.1.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.1.1) - 2021-08-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.1.0...v4.1.1)

### Fixed

- (IAC-1741) Allow stdlib v8.0.0 [#767](https://github.com/puppetlabs/puppetlabs-docker/pull/767) ([david22swan](https://github.com/david22swan))
- Remove stderr empty check to avoid docker_params_changed failures when warnings appear [#764](https://github.com/puppetlabs/puppetlabs-docker/pull/764) ([cedws](https://github.com/cedws))
- Duplicate declaration statement: docker_params_changed is already declared [#763](https://github.com/puppetlabs/puppetlabs-docker/pull/763) ([basti-nis](https://github.com/basti-nis))
- Timeout for hangs of the docker_client in the facts generation [#759](https://github.com/puppetlabs/puppetlabs-docker/pull/759) ([carabasdaniel](https://github.com/carabasdaniel))

## [v4.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.1.0) - 2021-06-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.0.1...v4.1.0)

### Added

- Add syslog_facility parameter to docker::run [#755](https://github.com/puppetlabs/puppetlabs-docker/pull/755) ([waipeng](https://github.com/waipeng))

### Fixed

- Fix docker::volumes hiera example [#754](https://github.com/puppetlabs/puppetlabs-docker/pull/754) ([pskopnik](https://github.com/pskopnik))
- Allow force update non-latest tagged image [#752](https://github.com/puppetlabs/puppetlabs-docker/pull/752) ([yanjunding](https://github.com/yanjunding))
- Allow management of the docker-ce-cli package [#740](https://github.com/puppetlabs/puppetlabs-docker/pull/740) ([kenyon](https://github.com/kenyon))

## [v4.0.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.0.1) - 2021-05-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.0.0...v4.0.1)

### Fixed

- (IAC-1497) - Removal of unsupported `translate` dependency [#737](https://github.com/puppetlabs/puppetlabs-docker/pull/737) ([david22swan](https://github.com/david22swan))
- add simple quotes around env service flag [#706](https://github.com/puppetlabs/puppetlabs-docker/pull/706) ([adrianiurca](https://github.com/adrianiurca))

## [v4.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.0.0) - 2021-03-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.14.0...v4.0.0)

## [v3.14.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.14.0) - 2021-03-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.13.1...v3.14.0)

### Changed
- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [#718](https://github.com/puppetlabs/puppetlabs-docker/pull/718) ([carabasdaniel](https://github.com/carabasdaniel))

### Fixed

- [MODULES-10898] Disable forced docker service restart for RedHat 7 and docker server 1.13 [#730](https://github.com/puppetlabs/puppetlabs-docker/pull/730) ([carabasdaniel](https://github.com/carabasdaniel))
- Make it possible to use pod's network [#725](https://github.com/puppetlabs/puppetlabs-docker/pull/725) ([seriv](https://github.com/seriv))

## [v3.13.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.13.1) - 2021-02-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.13.0...v3.13.1)

### Fixed

- (IAC-1218) - docker_params_changed should be run by agent [#705](https://github.com/puppetlabs/puppetlabs-docker/pull/705) ([adrianiurca](https://github.com/adrianiurca))
- Fix systemd units for systemd versions < v230 [#704](https://github.com/puppetlabs/puppetlabs-docker/pull/704) ([benningm](https://github.com/benningm))
- setting HOME environment to /root [#698](https://github.com/puppetlabs/puppetlabs-docker/pull/698) ([adrianiurca](https://github.com/adrianiurca))

## [v3.13.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.13.0) - 2020-12-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.12.1...v3.13.0)

### Added

- pdksync - (feat) - Bump Puppet boundary [#687](https://github.com/puppetlabs/puppetlabs-docker/pull/687) ([daianamezdrea](https://github.com/daianamezdrea))
- Ensure image digest checksum before starting [#673](https://github.com/puppetlabs/puppetlabs-docker/pull/673) ([tmanninger](https://github.com/tmanninger))
- Support multiple mirrors #659 [#669](https://github.com/puppetlabs/puppetlabs-docker/pull/669) ([TheLocehiliosan](https://github.com/TheLocehiliosan))

### Fixed

- Options to docker-compose should be an Array, not a String [#695](https://github.com/puppetlabs/puppetlabs-docker/pull/695) ([adrianiurca](https://github.com/adrianiurca))
- fixing issue #689 by setting HOME in docker command [#692](https://github.com/puppetlabs/puppetlabs-docker/pull/692) ([sdinten](https://github.com/sdinten))
- (MAINT) Use docker-compose config instead file parsing [#672](https://github.com/puppetlabs/puppetlabs-docker/pull/672) ([rbelnap](https://github.com/rbelnap))
- Fix array of additional flags [#671](https://github.com/puppetlabs/puppetlabs-docker/pull/671) ([CAPSLOCK2000](https://github.com/CAPSLOCK2000))
- Test against OS family rather than name [#667](https://github.com/puppetlabs/puppetlabs-docker/pull/667) ([bodgit](https://github.com/bodgit))

## [v3.12.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.12.1) - 2020-10-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.12.0...v3.12.1)

### Fixed

- Fix misplaced backslash in start template [#666](https://github.com/puppetlabs/puppetlabs-docker/pull/666) ([optiz0r](https://github.com/optiz0r))

## [v3.12.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.12.0) - 2020-09-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.11.0...v3.12.0)

### Added

- Add docker swarm join-tokens as facts [#651](https://github.com/puppetlabs/puppetlabs-docker/pull/651) ([oschusler](https://github.com/oschusler))

### Fixed

- (IAC-982) - Remove inappropriate terminology [#654](https://github.com/puppetlabs/puppetlabs-docker/pull/654) ([david22swan](https://github.com/david22swan))

## [v3.11.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.11.0) - 2020-08-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.10.2...v3.11.0)

### Added

- Fix #584: Deal with Arrays for the net list [#647](https://github.com/puppetlabs/puppetlabs-docker/pull/647) ([MG2R](https://github.com/MG2R))
- pdksync - (IAC-973) - Update travis/appveyor to run on new default branch main [#643](https://github.com/puppetlabs/puppetlabs-docker/pull/643) ([david22swan](https://github.com/david22swan))

### Fixed

- [MODULES-10734] - improve params detection on docker::run [#648](https://github.com/puppetlabs/puppetlabs-docker/pull/648) ([adrianiurca](https://github.com/adrianiurca))

## [v3.10.2](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.10.2) - 2020-07-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.10.1...v3.10.2)

### Fixed

- (MODULES-10691) - Add root_dir in daemon.json [#632](https://github.com/puppetlabs/puppetlabs-docker/pull/632) ([daianamezdrea](https://github.com/daianamezdrea))
- Fixing the fix 'Fix the docker_compose options parameter position #378' [#631](https://github.com/puppetlabs/puppetlabs-docker/pull/631) ([awegmann](https://github.com/awegmann))
- Blocking ordering between non-Windows service stops [#622](https://github.com/puppetlabs/puppetlabs-docker/pull/622) ([ALTinners](https://github.com/ALTinners))
- Allow all 3.x docker-compose minor versions [#620](https://github.com/puppetlabs/puppetlabs-docker/pull/620) ([runejuhl](https://github.com/runejuhl))

## [v3.10.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.10.1) - 2020-05-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.10.0...v3.10.1)

### Fixed

- Fix unreachable StartLimitBurst value in unit template [#616](https://github.com/puppetlabs/puppetlabs-docker/pull/616) ([omeinderink](https://github.com/omeinderink))
- (MODULES-9696) remove docker_home_dirs fact [#613](https://github.com/puppetlabs/puppetlabs-docker/pull/613) ([carabasdaniel](https://github.com/carabasdaniel))
- [MODULES-10629] Throw error when docker login fails [#610](https://github.com/puppetlabs/puppetlabs-docker/pull/610) ([carabasdaniel](https://github.com/carabasdaniel))
- (maint) - facts fix for centos [#608](https://github.com/puppetlabs/puppetlabs-docker/pull/608) ([david22swan](https://github.com/david22swan))
- major adjustments for current code style [#607](https://github.com/puppetlabs/puppetlabs-docker/pull/607) ([crazymind1337](https://github.com/crazymind1337))

## [v3.10.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.10.0) - 2020-04-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.9.1...v3.10.0)

### Added

- [IAC-291] Convert acceptance tests to Litmus [#585](https://github.com/puppetlabs/puppetlabs-docker/pull/585) ([carabasdaniel](https://github.com/carabasdaniel))
- Updated: Add Docker service (create, remote, scale) tasks [#582](https://github.com/puppetlabs/puppetlabs-docker/pull/582) ([Flask](https://github.com/Flask))
- Add after_start and after_stop options to docker::run define [#580](https://github.com/puppetlabs/puppetlabs-docker/pull/580) ([jantman](https://github.com/jantman))
- Make docker::machine::url configurable [#569](https://github.com/puppetlabs/puppetlabs-docker/pull/569) ([baurmatt](https://github.com/baurmatt))
- Let docker.service start docker services managed by puppetlabs/docker… [#563](https://github.com/puppetlabs/puppetlabs-docker/pull/563) ([jhejl](https://github.com/jhejl))
- Allow bypassing curl package ensure if needed [#477](https://github.com/puppetlabs/puppetlabs-docker/pull/477) ([esalberg](https://github.com/esalberg))

### Fixed

- Enforce TLS1.2 on Windows; minor fixes for RH-based testing [#603](https://github.com/puppetlabs/puppetlabs-docker/pull/603) ([carabasdaniel](https://github.com/carabasdaniel))
- [MODULES-10628] Update documentation for docker volume and set options as parameter [#599](https://github.com/puppetlabs/puppetlabs-docker/pull/599) ([carabasdaniel](https://github.com/carabasdaniel))
- Allow module to work on SLES [#591](https://github.com/puppetlabs/puppetlabs-docker/pull/591) ([npwalker](https://github.com/npwalker))
- (maint) Fix missing stubs in docker_spec.rb [#589](https://github.com/puppetlabs/puppetlabs-docker/pull/589) ([Filipovici-Andrei](https://github.com/Filipovici-Andrei))
- Add Hiera lookups for resources in init.pp [#586](https://github.com/puppetlabs/puppetlabs-docker/pull/586) ([fe80](https://github.com/fe80))
- Use standardized quote type to help tests pass [#566](https://github.com/puppetlabs/puppetlabs-docker/pull/566) ([DLeich](https://github.com/DLeich))
- Minimal changes to work with podman-docker [#562](https://github.com/puppetlabs/puppetlabs-docker/pull/562) ([seriv](https://github.com/seriv))

## [v3.9.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.9.1) - 2020-01-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.9.0...v3.9.1)

### Fixed

- (maint) fix dependencies of powershell to 4.0.0 [#568](https://github.com/puppetlabs/puppetlabs-docker/pull/568) ([sheenaajay](https://github.com/sheenaajay))

## [v3.9.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.9.0) - 2019-12-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.8.0...v3.9.0)

### Added

- Add option for RemainAfterExit [#549](https://github.com/puppetlabs/puppetlabs-docker/pull/549) ([vdavidoff](https://github.com/vdavidoff))

### Fixed

- Fix error does not show when image:tag does not exists (#552) [#553](https://github.com/puppetlabs/puppetlabs-docker/pull/553) ([rafaelcarv](https://github.com/rafaelcarv))
- Allow defining the name of the docker-compose symlink [#544](https://github.com/puppetlabs/puppetlabs-docker/pull/544) ([gtufte](https://github.com/gtufte))
- Clarify usage of docker_stack type up_args and fix link to docs [#537](https://github.com/puppetlabs/puppetlabs-docker/pull/537) ([jacksgt](https://github.com/jacksgt))
- Move StartLimit* options to [Unit], fix StartLimitIntervalSec [#531](https://github.com/puppetlabs/puppetlabs-docker/pull/531) ([runejuhl](https://github.com/runejuhl))

## [v3.8.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.8.0) - 2019-10-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.7.0-bna...v3.8.0)

### Added

- pdksync - Add support on Debian10 [#525](https://github.com/puppetlabs/puppetlabs-docker/pull/525) ([lionce](https://github.com/lionce))

### Fixed

- Fix multiple additional flags for docker_network [#523](https://github.com/puppetlabs/puppetlabs-docker/pull/523) ([lemrouch](https://github.com/lemrouch))
- :bug: Fix wrong service detach handling [#520](https://github.com/puppetlabs/puppetlabs-docker/pull/520) ([khaefeli](https://github.com/khaefeli))
- Fix aliased plugin names [#514](https://github.com/puppetlabs/puppetlabs-docker/pull/514) ([koshatul](https://github.com/koshatul))

## [v3.7.0-bna](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.7.0-bna) - 2019-08-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/e2.6...v3.7.0-bna)

### Added

- Add new Docker Swarm Tasks (node ls, rm, update; service scale) [#509](https://github.com/puppetlabs/puppetlabs-docker/pull/509) ([khaefeli](https://github.com/khaefeli))

### Fixed

- Fixing error: [#516](https://github.com/puppetlabs/puppetlabs-docker/pull/516) ([darshannnn](https://github.com/darshannnn))

## [e2.6](https://github.com/puppetlabs/puppetlabs-docker/tree/e2.6) - 2019-07-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.7.0...e2.6)

## [v3.7.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.7.0) - 2019-07-19

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.6.0...v3.7.0)

### Added

- Added option to override docker-compose download location [#482](https://github.com/puppetlabs/puppetlabs-docker/pull/482) ([piquet90](https://github.com/piquet90))

## [v3.6.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.6.0) - 2019-06-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.5.0...v3.6.0)

### Added

- (FM-8151) Add Windows Server 2019 support [#493](https://github.com/puppetlabs/puppetlabs-docker/pull/493) ([eimlav](https://github.com/eimlav))
- Support for docker machine download and install [#466](https://github.com/puppetlabs/puppetlabs-docker/pull/466) ([acurus-puppetmaster](https://github.com/acurus-puppetmaster))
- Add service_provider parameter to docker::run [#376](https://github.com/puppetlabs/puppetlabs-docker/pull/376) ([jameslikeslinux](https://github.com/jameslikeslinux))

### Changed
- (FM-8100) Update minimum supported Puppet version to 5.5.10 [#486](https://github.com/puppetlabs/puppetlabs-docker/pull/486) ([eimlav](https://github.com/eimlav))

### Fixed

- Tasks frozen string [#499](https://github.com/puppetlabs/puppetlabs-docker/pull/499) ([khaefeli](https://github.com/khaefeli))
- Fix #239 local_user permission denied [#497](https://github.com/puppetlabs/puppetlabs-docker/pull/497) ([thde](https://github.com/thde))
- (MODULES-9193) Revert part of MODULES-9177 [#490](https://github.com/puppetlabs/puppetlabs-docker/pull/490) ([eimlav](https://github.com/eimlav))
- (MODULES-9177) Fix version validation regex [#489](https://github.com/puppetlabs/puppetlabs-docker/pull/489) ([eimlav](https://github.com/eimlav))
- Fix publish flag being erroneously added to docker service commands [#471](https://github.com/puppetlabs/puppetlabs-docker/pull/471) ([twistedduck](https://github.com/twistedduck))
- Fix container running check to work for windows hosts [#470](https://github.com/puppetlabs/puppetlabs-docker/pull/470) ([florindragos](https://github.com/florindragos))
- Allow images tagged latest to update on each run [#468](https://github.com/puppetlabs/puppetlabs-docker/pull/468) ([electrofelix](https://github.com/electrofelix))
- Fix docker::image to not run images [#465](https://github.com/puppetlabs/puppetlabs-docker/pull/465) ([hugotanure](https://github.com/hugotanure))

## [3.5.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.5.0) - 2019-03-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.4.0...3.5.0)

### Fixed

- fix(syntax): Remove duplicate parenthesis [#454](https://github.com/puppetlabs/puppetlabs-docker/pull/454) ([jfroche](https://github.com/jfroche))
- Docker::Services:: fix command parameter used with an array [#452](https://github.com/puppetlabs/puppetlabs-docker/pull/452) ([jacksgt](https://github.com/jacksgt))
- docker::services: Fix using multiple published ports [#447](https://github.com/puppetlabs/puppetlabs-docker/pull/447) ([jacksgt](https://github.com/jacksgt))

## [3.4.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.4.0) - 2019-02-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/e2.0...3.4.0)

## [e2.0](https://github.com/puppetlabs/puppetlabs-docker/tree/e2.0) - 2019-02-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.3.0...e2.0)

### Fixed

- fixing errors with bundle file conditional statement [#436](https://github.com/puppetlabs/puppetlabs-docker/pull/436) ([davejrt](https://github.com/davejrt))
- #432 Fix frozen string error [#434](https://github.com/puppetlabs/puppetlabs-docker/pull/434) ([khaefeli](https://github.com/khaefeli))

## [3.3.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.3.0) - 2019-02-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.2.0...3.3.0)

## [3.2.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.2.0) - 2019-01-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.1.0...3.2.0)

### Fixed

- centos repo fix [#413](https://github.com/puppetlabs/puppetlabs-docker/pull/413) ([davejrt](https://github.com/davejrt))
- rhel fix [#412](https://github.com/puppetlabs/puppetlabs-docker/pull/412) ([davejrt](https://github.com/davejrt))
- fixing various issues with tests across all supported OS [#406](https://github.com/puppetlabs/puppetlabs-docker/pull/406) ([davejrt](https://github.com/davejrt))
- Fix shared scripts on non systemd systems [#400](https://github.com/puppetlabs/puppetlabs-docker/pull/400) ([glorpen](https://github.com/glorpen))
- Do not load powershell profiles [#396](https://github.com/puppetlabs/puppetlabs-docker/pull/396) ([florindragos](https://github.com/florindragos))
- Fix stack acceptance tests [#395](https://github.com/puppetlabs/puppetlabs-docker/pull/395) ([florindragos](https://github.com/florindragos))
- fixing acceptance tests on debian [#393](https://github.com/puppetlabs/puppetlabs-docker/pull/393) ([davejrt](https://github.com/davejrt))
- fixing deep merge issue and yaml alias [#387](https://github.com/puppetlabs/puppetlabs-docker/pull/387) ([davejrt](https://github.com/davejrt))
- Adds a Usage example for daemon level extra_parameters [#386](https://github.com/puppetlabs/puppetlabs-docker/pull/386) ([mpepping](https://github.com/mpepping))
- Fixing create_resources for volumes [#384](https://github.com/puppetlabs/puppetlabs-docker/pull/384) ([andytechdad](https://github.com/andytechdad))
- Fix the docker_compose options parameter position [#378](https://github.com/puppetlabs/puppetlabs-docker/pull/378) ([FlorentPoinsaut](https://github.com/FlorentPoinsaut))
- Allow multiple values for subnet in docker_network [#371](https://github.com/puppetlabs/puppetlabs-docker/pull/371) ([florindragos](https://github.com/florindragos))
- Cloud 2191 fix stack acceptance test [#368](https://github.com/puppetlabs/puppetlabs-docker/pull/368) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Create shared start/stop scripts for better extensibility [#367](https://github.com/puppetlabs/puppetlabs-docker/pull/367) ([glorpen](https://github.com/glorpen))
- Fixing incorrect variable names in docker_compose/ruby.rb [#365](https://github.com/puppetlabs/puppetlabs-docker/pull/365) ([lowerpuppet](https://github.com/lowerpuppet))
- update docker_stack to fix registry auth option [#364](https://github.com/puppetlabs/puppetlabs-docker/pull/364) ([davejrt](https://github.com/davejrt))
- Fix registry local_user functionalitity. [#353](https://github.com/puppetlabs/puppetlabs-docker/pull/353) ([stejanse](https://github.com/stejanse))
- Fix windows default paths [#326](https://github.com/puppetlabs/puppetlabs-docker/pull/326) ([florindragos](https://github.com/florindragos))

## [3.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.1.0) - 2018-10-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.0.0...3.1.0)

### Fixed

- Fix acceptance tests for windows [#349](https://github.com/puppetlabs/puppetlabs-docker/pull/349) ([florindragos](https://github.com/florindragos))
- pinning puppet version to fix failing spec tests [#346](https://github.com/puppetlabs/puppetlabs-docker/pull/346) ([MWilsonPuppet](https://github.com/MWilsonPuppet))

## [3.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.0.0) - 2018-09-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/2.0.0...3.0.0)

### Fixed

- Fix docker swarm tasks boolean params [#338](https://github.com/puppetlabs/puppetlabs-docker/pull/338) ([florindragos](https://github.com/florindragos))
- CLOUD-2069 Adding support for multiple compose files. [#332](https://github.com/puppetlabs/puppetlabs-docker/pull/332) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- fixes puppet run failures with no IPAM driver [#329](https://github.com/puppetlabs/puppetlabs-docker/pull/329) ([davejrt](https://github.com/davejrt))
- CLOUD-2078-Uninstall Docker on Linux [#328](https://github.com/puppetlabs/puppetlabs-docker/pull/328) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Fix error messages from docker facts if docker not running [#325](https://github.com/puppetlabs/puppetlabs-docker/pull/325) ([stdietrich](https://github.com/stdietrich))
- Fix docker-compose provider to support images built on the fly [#320](https://github.com/puppetlabs/puppetlabs-docker/pull/320) ([florindragos](https://github.com/florindragos))
- fixing bug in upstart systems [#304](https://github.com/puppetlabs/puppetlabs-docker/pull/304) ([davejrt](https://github.com/davejrt))
- Fix for registry password not being inserted due to single quotes [#299](https://github.com/puppetlabs/puppetlabs-docker/pull/299) ([ConorPKeegan](https://github.com/ConorPKeegan))
- Fix docker registry idempotency and add windows acceptance tests [#298](https://github.com/puppetlabs/puppetlabs-docker/pull/298) ([florindragos](https://github.com/florindragos))
- Regex fix [#292](https://github.com/puppetlabs/puppetlabs-docker/pull/292) ([davejrt](https://github.com/davejrt))

## [2.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/2.0.0) - 2018-07-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.1.0...2.0.0)

### Fixed

- fixes restarting containers with changes to run arguments [#283](https://github.com/puppetlabs/puppetlabs-docker/pull/283) ([davejrt](https://github.com/davejrt))
- fix "start a container with cpuset" acceptance test on ubuntu1404 [#236](https://github.com/puppetlabs/puppetlabs-docker/pull/236) ([mihaibuzgau](https://github.com/mihaibuzgau))

## [1.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/1.1.0) - 2018-03-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/e1.1...1.1.0)

### Fixed

- (maint)CLOUD-1768 Fixing incorrect cpuset flag #183 [#187](https://github.com/puppetlabs/puppetlabs-docker/pull/187) ([MWilsonPuppet](https://github.com/MWilsonPuppet))

## [e1.1](https://github.com/puppetlabs/puppetlabs-docker/tree/e1.1) - 2018-02-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.5...e1.1)

### Fixed

- fix typo [#149](https://github.com/puppetlabs/puppetlabs-docker/pull/149) ([seriv](https://github.com/seriv))

## [1.0.5](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.5) - 2018-01-31

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.4...1.0.5)

## [1.0.4](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.4) - 2018-01-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.3...1.0.4)

## [1.0.3](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.3) - 2018-01-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/e1.0...1.0.3)

## [e1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/e1.0) - 2017-12-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.2...e1.0)

## [1.0.2](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.2) - 2017-11-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.1...1.0.2)

## [1.0.1](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.1) - 2017-10-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.0) - 2017-10-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/790d08e2a1191db1b6c61f299d259fcd28cfa4e0...1.0.0)
