# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v6.0.2](https://github.com/puppetlabs/puppetlabs-docker/tree/v6.0.2) (2022-12-07)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v6.0.1...v6.0.2)

### Fixed

- \(CONT-24\) docker_stack always redoploying [\#878](https://github.com/puppetlabs/puppetlabs-docker/pull/878) ([david22swan](https://github.com/david22swan))

## [v6.0.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v6.0.1) (2022-11-25)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v6.0.0...v6.0.1)

### Fixed

- Revert "\(maint\) Hardening manifests and tasks" [\#875](https://github.com/puppetlabs/puppetlabs-docker/pull/875) ([pmcmaw](https://github.com/pmcmaw))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v6.0.0) (2022-11-21)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v5.1.0...v6.0.0)

### Changed

- \(CONT-263\) Bumping required puppet version [\#871](https://github.com/puppetlabs/puppetlabs-docker/pull/871) ([LukasAud](https://github.com/LukasAud))
- docker\_run\_flags: Shellescape any provided values [\#869](https://github.com/puppetlabs/puppetlabs-docker/pull/869) ([LukasAud](https://github.com/LukasAud))
- \(maint\) Hardening manifests and tasks [\#863](https://github.com/puppetlabs/puppetlabs-docker/pull/863) ([LukasAud](https://github.com/LukasAud))

## [v5.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v5.1.0) (2022-10-21)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v5.0.0...v5.1.0)

### Added

- Add missing extra\_systemd\_parameters values to docker-run.erb [\#851](https://github.com/puppetlabs/puppetlabs-docker/pull/851) ([cbowman0](https://github.com/cbowman0))

### Fixed

- pdksync - \(CONT-130\) Dropping Support for Debian 9 [\#859](https://github.com/puppetlabs/puppetlabs-docker/pull/859) ([jordanbreen28](https://github.com/jordanbreen28))
- Change `stop_wait_time` value to match Docker default [\#858](https://github.com/puppetlabs/puppetlabs-docker/pull/858) ([sebcdri](https://github.com/sebcdri))

## [v5.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v5.0.0) (2022-08-19)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.4.0...v5.0.0)

### Changed

- Remove log\_driver limitations [\#792](https://github.com/puppetlabs/puppetlabs-docker/pull/792) ([timdeluxe](https://github.com/timdeluxe))

### Added

- pdksync - \(GH-cat-11\) Certify Support for Ubuntu 22.04 [\#850](https://github.com/puppetlabs/puppetlabs-docker/pull/850) ([david22swan](https://github.com/david22swan))
- adding optional variable for package\_key\_check\_source to RedHat [\#846](https://github.com/puppetlabs/puppetlabs-docker/pull/846) ([STaegtmeier](https://github.com/STaegtmeier))
- New create\_user parameter on main class [\#841](https://github.com/puppetlabs/puppetlabs-docker/pull/841) ([traylenator](https://github.com/traylenator))

## [v4.4.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.4.0) (2022-06-01)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.3.0...v4.4.0)

### Added

- Update Docker Compose to handle symbols [\#834](https://github.com/puppetlabs/puppetlabs-docker/pull/834) ([sili72](https://github.com/sili72))

### Fixed

- Avoid empty array to -net parameter [\#837](https://github.com/puppetlabs/puppetlabs-docker/pull/837) ([chelnak](https://github.com/chelnak))
- \(GH-785\) Fix duplicate stack matching [\#836](https://github.com/puppetlabs/puppetlabs-docker/pull/836) ([chelnak](https://github.com/chelnak))
- Fix docker-compose, network and volumes not applying on 1st run, fix other idempotency [\#833](https://github.com/puppetlabs/puppetlabs-docker/pull/833) ([canihavethisone](https://github.com/canihavethisone))
- Fixed docker facts to check for active swarm clusters before running docker swarm sub-commands. [\#817](https://github.com/puppetlabs/puppetlabs-docker/pull/817) ([nmaludy](https://github.com/nmaludy))

## [v4.3.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.3.0) (2022-05-16)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.2.1...v4.3.0)

### Added

- Add tmpdir option to docker\_compose [\#823](https://github.com/puppetlabs/puppetlabs-docker/pull/823) ([canihavethisone](https://github.com/canihavethisone))
- Support different Architectures \(like `aarch64`\) when installing Compose [\#812](https://github.com/puppetlabs/puppetlabs-docker/pull/812) ([mpdude](https://github.com/mpdude))

### Fixed

- Only install docker-ce-cli with docker-ce [\#827](https://github.com/puppetlabs/puppetlabs-docker/pull/827) ([vchepkov](https://github.com/vchepkov))
- remove some legacy facts [\#802](https://github.com/puppetlabs/puppetlabs-docker/pull/802) ([traylenator](https://github.com/traylenator))
- Fix missing comma in docker::image example [\#787](https://github.com/puppetlabs/puppetlabs-docker/pull/787) ([Vincevrp](https://github.com/Vincevrp))
- allow docker::networks::networks param to be undef [\#783](https://github.com/puppetlabs/puppetlabs-docker/pull/783) ([jhoblitt](https://github.com/jhoblitt))

## [v4.2.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.2.1) (2022-04-14)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.2.0...v4.2.1)

### Fixed

- Fix permission denied issue introduced in v4.2.0 [\#820](https://github.com/puppetlabs/puppetlabs-docker/pull/820) ([chelnak](https://github.com/chelnak))

## [v4.2.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.2.0) (2022-04-11)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.1.2...v4.2.0)

### Added

- pdksync - \(FM-8922\) - Add Support for Windows 2022 [\#801](https://github.com/puppetlabs/puppetlabs-docker/pull/801) ([david22swan](https://github.com/david22swan))
- \(IAC-1729\) Add Support for Debian 11 [\#799](https://github.com/puppetlabs/puppetlabs-docker/pull/799) ([david22swan](https://github.com/david22swan))

### Fixed

- pdksync - \(GH-iac-334\) Remove Support for Ubuntu 14.04/16.04 [\#807](https://github.com/puppetlabs/puppetlabs-docker/pull/807) ([david22swan](https://github.com/david22swan))
- Fix idempotency when using scaling with docker-compose [\#805](https://github.com/puppetlabs/puppetlabs-docker/pull/805) ([canihavethisone](https://github.com/canihavethisone))
- Make RedHat version check respect acknowledge\_unsupported\_os [\#788](https://github.com/puppetlabs/puppetlabs-docker/pull/788) ([PolaricEntropy](https://github.com/PolaricEntropy))

## [v4.1.2](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.1.2) (2021-09-27)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.1.1...v4.1.2)

### Fixed

- pdksync - \(IAC-1598\) - Remove Support for Debian 8 [\#775](https://github.com/puppetlabs/puppetlabs-docker/pull/775) ([david22swan](https://github.com/david22swan))
- Prefer timeout to time\_limit for Facter::Core::Execution [\#774](https://github.com/puppetlabs/puppetlabs-docker/pull/774) ([smortex](https://github.com/smortex))
- Fix facts gathering [\#773](https://github.com/puppetlabs/puppetlabs-docker/pull/773) ([smortex](https://github.com/smortex))

## [v4.1.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.1.1) (2021-08-26)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.1.0...v4.1.1)

### Fixed

- \(IAC-1741\) Allow stdlib v8.0.0 [\#767](https://github.com/puppetlabs/puppetlabs-docker/pull/767) ([david22swan](https://github.com/david22swan))
- Remove stderr empty check to avoid docker\_params\_changed failures when warnings appear [\#764](https://github.com/puppetlabs/puppetlabs-docker/pull/764) ([cedws](https://github.com/cedws))
- Duplicate declaration statement: docker\_params\_changed is already declared [\#763](https://github.com/puppetlabs/puppetlabs-docker/pull/763) ([basti-nis](https://github.com/basti-nis))
- Timeout for hangs of the docker\_client in the facts generation [\#759](https://github.com/puppetlabs/puppetlabs-docker/pull/759) ([carabasdaniel](https://github.com/carabasdaniel))

## [v4.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.1.0) (2021-06-28)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.0.1...v4.1.0)

### Added

- Add syslog\_facility parameter to docker::run [\#755](https://github.com/puppetlabs/puppetlabs-docker/pull/755) ([waipeng](https://github.com/waipeng))

### Fixed

- Fix docker::volumes hiera example [\#754](https://github.com/puppetlabs/puppetlabs-docker/pull/754) ([pskopnik](https://github.com/pskopnik))
- Allow force update non-latest tagged image [\#752](https://github.com/puppetlabs/puppetlabs-docker/pull/752) ([yanjunding](https://github.com/yanjunding))
- Allow management of the docker-ce-cli package [\#740](https://github.com/puppetlabs/puppetlabs-docker/pull/740) ([kenyon](https://github.com/kenyon))

## [v4.0.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.0.1) (2021-05-26)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v4.0.0...v4.0.1)

### Fixed

- \(IAC-1497\) - Removal of unsupported `translate` dependency [\#737](https://github.com/puppetlabs/puppetlabs-docker/pull/737) ([david22swan](https://github.com/david22swan))
- add simple quotes around env service flag [\#706](https://github.com/puppetlabs/puppetlabs-docker/pull/706) ([adrianiurca](https://github.com/adrianiurca))

## [v4.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v4.0.0) (2021-03-04)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.14.0...v4.0.0)

### Changed

- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [\#718](https://github.com/puppetlabs/puppetlabs-docker/pull/718) ([carabasdaniel](https://github.com/carabasdaniel))

### Fixed

- Make it possible to use pod's network [\#725](https://github.com/puppetlabs/puppetlabs-docker/pull/725) ([seriv](https://github.com/seriv))

## [v3.14.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.14.0) (2021-03-04)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.13.1...v3.14.0)

### Fixed

- \[MODULES-10898\] Disable forced docker service restart for RedHat 7 and docker server 1.13 [\#730](https://github.com/puppetlabs/puppetlabs-docker/pull/730) ([carabasdaniel](https://github.com/carabasdaniel))

## [v3.13.1](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.13.1) (2021-02-02)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.13.0...v3.13.1)

### Fixed

- \(IAC-1218\) - docker\_params\_changed should be run by agent [\#705](https://github.com/puppetlabs/puppetlabs-docker/pull/705) ([adrianiurca](https://github.com/adrianiurca))
- Fix systemd units for systemd versions \< v230 [\#704](https://github.com/puppetlabs/puppetlabs-docker/pull/704) ([benningm](https://github.com/benningm))
- setting HOME environment to /root [\#698](https://github.com/puppetlabs/puppetlabs-docker/pull/698) ([adrianiurca](https://github.com/adrianiurca))

## [v3.13.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.13.0) (2020-12-14)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.12.1...v3.13.0)

### Added

- pdksync - \(feat\) - Bump Puppet boundary [\#687](https://github.com/puppetlabs/puppetlabs-docker/pull/687) ([daianamezdrea](https://github.com/daianamezdrea))
- Ensure image digest checksum before starting [\#673](https://github.com/puppetlabs/puppetlabs-docker/pull/673) ([tmanninger](https://github.com/tmanninger))
- Support multiple mirrors \#659 [\#669](https://github.com/puppetlabs/puppetlabs-docker/pull/669) ([TheLocehiliosan](https://github.com/TheLocehiliosan))

### Fixed

- Options to docker-compose should be an Array, not a String [\#695](https://github.com/puppetlabs/puppetlabs-docker/pull/695) ([adrianiurca](https://github.com/adrianiurca))
- fixing issue \#689 by setting HOME in docker command [\#692](https://github.com/puppetlabs/puppetlabs-docker/pull/692) ([sdinten](https://github.com/sdinten))
- \(MAINT\) Use docker-compose config instead file parsing [\#672](https://github.com/puppetlabs/puppetlabs-docker/pull/672) ([rbelnap](https://github.com/rbelnap))
- Fix array of additional flags [\#671](https://github.com/puppetlabs/puppetlabs-docker/pull/671) ([CAPSLOCK2000](https://github.com/CAPSLOCK2000))
- Test against OS family rather than name [\#667](https://github.com/puppetlabs/puppetlabs-docker/pull/667) ([bodgit](https://github.com/bodgit))

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

### Fixed

- \[MODULES-10734\] - improve params detection on docker::run [\#648](https://github.com/puppetlabs/puppetlabs-docker/pull/648) ([adrianiurca](https://github.com/adrianiurca))

## [v3.10.2](https://github.com/puppetlabs/puppetlabs-docker/tree/v3.10.2) (2020-07-16)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v3.10.1...v3.10.2)

### Fixed

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
- Allow bypassing curl package ensure if needed [\#477](https://github.com/puppetlabs/puppetlabs-docker/pull/477) ([esalberg](https://github.com/esalberg))

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
- Support for docker machine download and install [\#466](https://github.com/puppetlabs/puppetlabs-docker/pull/466) ([acurus-puppetmaster](https://github.com/acurus-puppetmaster))
- Add service\_provider parameter to docker::run [\#376](https://github.com/puppetlabs/puppetlabs-docker/pull/376) ([jameslikeslinux](https://github.com/jameslikeslinux))

### Fixed

- Tasks frozen string [\#499](https://github.com/puppetlabs/puppetlabs-docker/pull/499) ([khaefeli](https://github.com/khaefeli))
- Fix \#239 local\_user permission denied [\#497](https://github.com/puppetlabs/puppetlabs-docker/pull/497) ([thde](https://github.com/thde))
- \(MODULES-9193\) Revert part of MODULES-9177 [\#490](https://github.com/puppetlabs/puppetlabs-docker/pull/490) ([eimlav](https://github.com/eimlav))
- \(MODULES-9177\) Fix version validation regex [\#489](https://github.com/puppetlabs/puppetlabs-docker/pull/489) ([eimlav](https://github.com/eimlav))
- Fix publish flag being erroneously added to docker service commands [\#471](https://github.com/puppetlabs/puppetlabs-docker/pull/471) ([twistedduck](https://github.com/twistedduck))
- Fix container running check to work for windows hosts [\#470](https://github.com/puppetlabs/puppetlabs-docker/pull/470) ([florindragos](https://github.com/florindragos))
- Allow images tagged latest to update on each run [\#468](https://github.com/puppetlabs/puppetlabs-docker/pull/468) ([electrofelix](https://github.com/electrofelix))
- Fix docker::image to not run images [\#465](https://github.com/puppetlabs/puppetlabs-docker/pull/465) ([hugotanure](https://github.com/hugotanure))

## [3.5.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.5.0) (2019-03-14)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.4.0...3.5.0)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- release 3.5.0 [\#458](https://github.com/puppetlabs/puppetlabs-docker/pull/458) ([davejrt](https://github.com/davejrt))
- fix\(syntax\): Remove duplicate parenthesis [\#454](https://github.com/puppetlabs/puppetlabs-docker/pull/454) ([jfroche](https://github.com/jfroche))
- making dependency ranges more logical [\#453](https://github.com/puppetlabs/puppetlabs-docker/pull/453) ([davejrt](https://github.com/davejrt))
- Docker::Services:: fix command parameter used with an array [\#452](https://github.com/puppetlabs/puppetlabs-docker/pull/452) ([jacksgt](https://github.com/jacksgt))
- adding in capability to attach multiple networks to container [\#451](https://github.com/puppetlabs/puppetlabs-docker/pull/451) ([davejrt](https://github.com/davejrt))
- Docker::Services: Add networks parameter for swarm services [\#450](https://github.com/puppetlabs/puppetlabs-docker/pull/450) ([jacksgt](https://github.com/jacksgt))
- Add ability to set service\_after\_override to false [\#448](https://github.com/puppetlabs/puppetlabs-docker/pull/448) ([esalberg](https://github.com/esalberg))
- docker::services: Fix using multiple published ports [\#447](https://github.com/puppetlabs/puppetlabs-docker/pull/447) ([jacksgt](https://github.com/jacksgt))
- Add ability to override After for docker.service [\#446](https://github.com/puppetlabs/puppetlabs-docker/pull/446) ([esalberg](https://github.com/esalberg))

## [3.4.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.4.0) (2019-02-25)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/e2.0...3.4.0)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- adding in documentation for use of stack type/provider [\#443](https://github.com/puppetlabs/puppetlabs-docker/pull/443) ([davejrt](https://github.com/davejrt))
- release for v3.4.0 [\#442](https://github.com/puppetlabs/puppetlabs-docker/pull/442) ([davejrt](https://github.com/davejrt))
- Add docker socket group overrides for systemd \(service and socket\) [\#441](https://github.com/puppetlabs/puppetlabs-docker/pull/441) ([esalberg](https://github.com/esalberg))
- changing permissions to remove systemd warning [\#440](https://github.com/puppetlabs/puppetlabs-docker/pull/440) ([davejrt](https://github.com/davejrt))
- including docker class in all tests of docker::run [\#437](https://github.com/puppetlabs/puppetlabs-docker/pull/437) ([davejrt](https://github.com/davejrt))
- fixing errors with bundle file conditional statement [\#436](https://github.com/puppetlabs/puppetlabs-docker/pull/436) ([davejrt](https://github.com/davejrt))
- \#432 Fix frozen string error [\#434](https://github.com/puppetlabs/puppetlabs-docker/pull/434) ([khaefeli](https://github.com/khaefeli))
- adding in type/provider for docker stack [\#433](https://github.com/puppetlabs/puppetlabs-docker/pull/433) ([davejrt](https://github.com/davejrt))
- Allow custom docker\_group and service\_name values in run.pp [\#431](https://github.com/puppetlabs/puppetlabs-docker/pull/431) ([esalberg](https://github.com/esalberg))
- updating acceptance tests for cve-2019-5736 [\#430](https://github.com/puppetlabs/puppetlabs-docker/pull/430) ([davejrt](https://github.com/davejrt))
- updating translate module version [\#429](https://github.com/puppetlabs/puppetlabs-docker/pull/429) ([davejrt](https://github.com/davejrt))

## [e2.0](https://github.com/puppetlabs/puppetlabs-docker/tree/e2.0) (2019-02-21)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.3.0...e2.0)

## [3.3.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.3.0) (2019-02-13)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.2.0...3.3.0)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- updating changelog and metadata for release [\#427](https://github.com/puppetlabs/puppetlabs-docker/pull/427) ([davejrt](https://github.com/davejrt))
- provide a more flexible range for the reboot module [\#426](https://github.com/puppetlabs/puppetlabs-docker/pull/426) ([davejrt](https://github.com/davejrt))
- Increase apt pin from 10 to 500 [\#425](https://github.com/puppetlabs/puppetlabs-docker/pull/425) ([baurmatt](https://github.com/baurmatt))
- don't fail if docker server is not running \(\#422\) [\#423](https://github.com/puppetlabs/puppetlabs-docker/pull/423) ([vchepkov](https://github.com/vchepkov))
- Docker::Services: Add 'mounts' parameter [\#421](https://github.com/puppetlabs/puppetlabs-docker/pull/421) ([jacksgt](https://github.com/jacksgt))
- readme udpate [\#416](https://github.com/puppetlabs/puppetlabs-docker/pull/416) ([davejrt](https://github.com/davejrt))
- centos repo fix [\#413](https://github.com/puppetlabs/puppetlabs-docker/pull/413) ([davejrt](https://github.com/davejrt))
- rhel fix [\#412](https://github.com/puppetlabs/puppetlabs-docker/pull/412) ([davejrt](https://github.com/davejrt))
- Stack spec [\#411](https://github.com/puppetlabs/puppetlabs-docker/pull/411) ([davejrt](https://github.com/davejrt))
- \(CLOUD-2201\) Readme updates [\#410](https://github.com/puppetlabs/puppetlabs-docker/pull/410) ([EamonnTP](https://github.com/EamonnTP))
- Fix unit tests on windows [\#409](https://github.com/puppetlabs/puppetlabs-docker/pull/409) ([florindragos](https://github.com/florindragos))
- Removing underscore characters from local\_user variable before using it with stdlib's pw\_hash [\#408](https://github.com/puppetlabs/puppetlabs-docker/pull/408) ([venushka](https://github.com/venushka))

## [3.2.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.2.0) (2019-01-16)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.1.0...3.2.0)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- fixing various issues with tests across all supported OS [\#406](https://github.com/puppetlabs/puppetlabs-docker/pull/406) ([davejrt](https://github.com/davejrt))
- updating changelog and metadata for release [\#405](https://github.com/puppetlabs/puppetlabs-docker/pull/405) ([davejrt](https://github.com/davejrt))
- Merge-back of release branch into master [\#361](https://github.com/puppetlabs/puppetlabs-docker/pull/361) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Update readme for docker stack [\#359](https://github.com/puppetlabs/puppetlabs-docker/pull/359) ([florindragos](https://github.com/florindragos))
- Add docker stack tests [\#356](https://github.com/puppetlabs/puppetlabs-docker/pull/356) ([florindragos](https://github.com/florindragos))
- Added support for awslogs [\#354](https://github.com/puppetlabs/puppetlabs-docker/pull/354) ([acurus-puppetmaster](https://github.com/acurus-puppetmaster))
- Fix registry local\_user functionalitity. [\#353](https://github.com/puppetlabs/puppetlabs-docker/pull/353) ([stejanse](https://github.com/stejanse))
- Docker stack on windows [\#350](https://github.com/puppetlabs/puppetlabs-docker/pull/350) ([florindragos](https://github.com/florindragos))
- Fix acceptance tests for windows [\#349](https://github.com/puppetlabs/puppetlabs-docker/pull/349) ([florindragos](https://github.com/florindragos))
- post release rebase of release branch into master [\#347](https://github.com/puppetlabs/puppetlabs-docker/pull/347) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- CLOUD-2146 cleanup of docker compose acceptance tests [\#341](https://github.com/puppetlabs/puppetlabs-docker/pull/341) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- adding in support for ubuntu 18.04 [\#340](https://github.com/puppetlabs/puppetlabs-docker/pull/340) ([davejrt](https://github.com/davejrt))
- Check for empty IPAM Config [\#339](https://github.com/puppetlabs/puppetlabs-docker/pull/339) ([florindragos](https://github.com/florindragos))
- Fix docker swarm tasks boolean params [\#338](https://github.com/puppetlabs/puppetlabs-docker/pull/338) ([florindragos](https://github.com/florindragos))
- Update readme - Using a proxy on windows [\#337](https://github.com/puppetlabs/puppetlabs-docker/pull/337) ([florindragos](https://github.com/florindragos))
- adding in official support of ubuntu 18.04 [\#333](https://github.com/puppetlabs/puppetlabs-docker/pull/333) ([davejrt](https://github.com/davejrt))
- CLOUD-2069 Adding support for multiple compose files. [\#332](https://github.com/puppetlabs/puppetlabs-docker/pull/332) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Docker network [\#331](https://github.com/puppetlabs/puppetlabs-docker/pull/331) ([davejrt](https://github.com/davejrt))
- Use versioncmp instead of  type casting [\#330](https://github.com/puppetlabs/puppetlabs-docker/pull/330) ([PierreR](https://github.com/PierreR))
- fixes puppet run failures with no IPAM driver [\#329](https://github.com/puppetlabs/puppetlabs-docker/pull/329) ([davejrt](https://github.com/davejrt))
- CLOUD-2078-Uninstall Docker on Linux [\#328](https://github.com/puppetlabs/puppetlabs-docker/pull/328) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- More idiomatic usage of parens for 'fail translate\(\(' [\#327](https://github.com/puppetlabs/puppetlabs-docker/pull/327) ([PierreR](https://github.com/PierreR))
- Fix windows default paths [\#326](https://github.com/puppetlabs/puppetlabs-docker/pull/326) ([florindragos](https://github.com/florindragos))
- Fix error messages from docker facts if docker not running [\#325](https://github.com/puppetlabs/puppetlabs-docker/pull/325) ([stdietrich](https://github.com/stdietrich))
- add custom\_unless for docker::run exec [\#324](https://github.com/puppetlabs/puppetlabs-docker/pull/324) ([esalberg](https://github.com/esalberg))
- Fix docker-compose provider to support images built on the fly [\#320](https://github.com/puppetlabs/puppetlabs-docker/pull/320) ([florindragos](https://github.com/florindragos))
- Windows - remove docker on ensure absent [\#318](https://github.com/puppetlabs/puppetlabs-docker/pull/318) ([florindragos](https://github.com/florindragos))
- Receive osfamily as parameter in docker\_run\_flags [\#317](https://github.com/puppetlabs/puppetlabs-docker/pull/317) ([florindragos](https://github.com/florindragos))
- Add acceptance tests for installing docker from a zip file on windows [\#315](https://github.com/puppetlabs/puppetlabs-docker/pull/315) ([florindragos](https://github.com/florindragos))
- Add option to download and install docker from a url on windows [\#311](https://github.com/puppetlabs/puppetlabs-docker/pull/311) ([florindragos](https://github.com/florindragos))
- CLOUD-2046-Add logic for root dir flag [\#306](https://github.com/puppetlabs/puppetlabs-docker/pull/306) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- fixing bug in upstart systems [\#304](https://github.com/puppetlabs/puppetlabs-docker/pull/304) ([davejrt](https://github.com/davejrt))
- adds in exec unit test for addition of env vars into exec define [\#302](https://github.com/puppetlabs/puppetlabs-docker/pull/302) ([davejrt](https://github.com/davejrt))
- removing keyring packages, no longer required  [\#301](https://github.com/puppetlabs/puppetlabs-docker/pull/301) ([davejrt](https://github.com/davejrt))
- \[CLOUD-2040\]enable extras repo only in CentOS 6 or lower [\#300](https://github.com/puppetlabs/puppetlabs-docker/pull/300) ([mihaibuzgau](https://github.com/mihaibuzgau))
- Fix for registry password not being inserted due to single quotes [\#299](https://github.com/puppetlabs/puppetlabs-docker/pull/299) ([ConorPKeegan](https://github.com/ConorPKeegan))
- Fix docker registry idempotency and add windows acceptance tests [\#298](https://github.com/puppetlabs/puppetlabs-docker/pull/298) ([florindragos](https://github.com/florindragos))
- \[CLOUD-1981\] docker image update script runs in noop mode [\#297](https://github.com/puppetlabs/puppetlabs-docker/pull/297) ([mihaibuzgau](https://github.com/mihaibuzgau))
- \[CLOUD-2041\] Windows service idempotence using powershell script [\#295](https://github.com/puppetlabs/puppetlabs-docker/pull/295) ([mihaibuzgau](https://github.com/mihaibuzgau))
- Regex fix [\#292](https://github.com/puppetlabs/puppetlabs-docker/pull/292) ([davejrt](https://github.com/davejrt))
- Do not use = for to set storage driver - fixes starting of docker-sto… [\#291](https://github.com/puppetlabs/puppetlabs-docker/pull/291) ([duritong](https://github.com/duritong))
- \[CLOUD-2033\] determine if a compose service extends another compose service [\#288](https://github.com/puppetlabs/puppetlabs-docker/pull/288) ([mihaibuzgau](https://github.com/mihaibuzgau))
- 2.0.0 [\#286](https://github.com/puppetlabs/puppetlabs-docker/pull/286) ([davejrt](https://github.com/davejrt))
- Pass supplied environment variables to docker exec [\#135](https://github.com/puppetlabs/puppetlabs-docker/pull/135) ([jorhett](https://github.com/jorhett))
- Removing value in the --prune parameter for docker stack deploy [\#407](https://github.com/puppetlabs/puppetlabs-docker/pull/407) ([venushka](https://github.com/venushka))
- Cleanup containers spec [\#404](https://github.com/puppetlabs/puppetlabs-docker/pull/404) ([davejrt](https://github.com/davejrt))
- Move container name sanitisation code to puppet function. [\#401](https://github.com/puppetlabs/puppetlabs-docker/pull/401) ([glorpen](https://github.com/glorpen))
- Fix shared scripts on non systemd systems [\#400](https://github.com/puppetlabs/puppetlabs-docker/pull/400) ([glorpen](https://github.com/glorpen))
- debian 9 and ubuntu 1804 pooler tests [\#399](https://github.com/puppetlabs/puppetlabs-docker/pull/399) ([davejrt](https://github.com/davejrt))
- Update .travis.yml [\#398](https://github.com/puppetlabs/puppetlabs-docker/pull/398) ([davejrt](https://github.com/davejrt))
- Do not load powershell profiles [\#396](https://github.com/puppetlabs/puppetlabs-docker/pull/396) ([florindragos](https://github.com/florindragos))
- Fix stack acceptance tests [\#395](https://github.com/puppetlabs/puppetlabs-docker/pull/395) ([florindragos](https://github.com/florindragos))
- fixing acceptance tests on debian [\#393](https://github.com/puppetlabs/puppetlabs-docker/pull/393) ([davejrt](https://github.com/davejrt))
- Add support for default-addr-pool options to swarm init [\#391](https://github.com/puppetlabs/puppetlabs-docker/pull/391) ([sagepe](https://github.com/sagepe))
- Enable PDK compliance [\#389](https://github.com/puppetlabs/puppetlabs-docker/pull/389) ([florindragos](https://github.com/florindragos))
- fixing deep merge issue and yaml alias [\#387](https://github.com/puppetlabs/puppetlabs-docker/pull/387) ([davejrt](https://github.com/davejrt))
- Adds a Usage example for daemon level extra\_parameters [\#386](https://github.com/puppetlabs/puppetlabs-docker/pull/386) ([mpepping](https://github.com/mpepping))
- Fixing create\_resources for volumes [\#384](https://github.com/puppetlabs/puppetlabs-docker/pull/384) ([andytechdad](https://github.com/andytechdad))
- docker::run: Support depend\_services with full systemd unit names [\#383](https://github.com/puppetlabs/puppetlabs-docker/pull/383) ([jameslikeslinux](https://github.com/jameslikeslinux))
- \(WIP\) - removes packages that can still run docker after docker-ce is removed.  [\#379](https://github.com/puppetlabs/puppetlabs-docker/pull/379) ([davejrt](https://github.com/davejrt))
- Fix the docker\_compose options parameter position [\#378](https://github.com/puppetlabs/puppetlabs-docker/pull/378) ([FlorentPoinsaut](https://github.com/FlorentPoinsaut))
- missing quote in swarm documentation [\#377](https://github.com/puppetlabs/puppetlabs-docker/pull/377) ([lcrownover](https://github.com/lcrownover))
- Puppet 6 support [\#375](https://github.com/puppetlabs/puppetlabs-docker/pull/375) ([florindragos](https://github.com/florindragos))
- Update default network example [\#374](https://github.com/puppetlabs/puppetlabs-docker/pull/374) ([davejrt](https://github.com/davejrt))
- Handle compose files with services that have no image [\#373](https://github.com/puppetlabs/puppetlabs-docker/pull/373) ([walkamongus](https://github.com/walkamongus))
- Allow multiple values for subnet in docker\_network [\#371](https://github.com/puppetlabs/puppetlabs-docker/pull/371) ([florindragos](https://github.com/florindragos))
- parameterized package\_location for osfamily==RedHat [\#370](https://github.com/puppetlabs/puppetlabs-docker/pull/370) ([ZyanKLee](https://github.com/ZyanKLee))
- Cloud 2191 fix stack acceptance test [\#368](https://github.com/puppetlabs/puppetlabs-docker/pull/368) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Create shared start/stop scripts for better extensibility [\#367](https://github.com/puppetlabs/puppetlabs-docker/pull/367) ([glorpen](https://github.com/glorpen))
- rework all indentation [\#366](https://github.com/puppetlabs/puppetlabs-docker/pull/366) ([kapouik](https://github.com/kapouik))
- Fixing incorrect variable names in docker\_compose/ruby.rb [\#365](https://github.com/puppetlabs/puppetlabs-docker/pull/365) ([lowerpuppet](https://github.com/lowerpuppet))
- update docker\_stack to fix registry auth option [\#364](https://github.com/puppetlabs/puppetlabs-docker/pull/364) ([davejrt](https://github.com/davejrt))

## [3.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.1.0) (2018-10-22)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/3.0.0...3.1.0)

## [3.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/3.0.0) (2018-09-27)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/2.0.0...3.0.0)

## [2.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/2.0.0) (2018-07-18)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.1.0...2.0.0)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- Update metadata.json [\#285](https://github.com/puppetlabs/puppetlabs-docker/pull/285) ([davejrt](https://github.com/davejrt))
- Health fix [\#284](https://github.com/puppetlabs/puppetlabs-docker/pull/284) ([davejrt](https://github.com/davejrt))
- fixes restarting containers with changes to run arguments [\#283](https://github.com/puppetlabs/puppetlabs-docker/pull/283) ([davejrt](https://github.com/davejrt))
- 2.0.0 release prep. [\#282](https://github.com/puppetlabs/puppetlabs-docker/pull/282) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- CLOUD-2018-Add-health-check-interval [\#279](https://github.com/puppetlabs/puppetlabs-docker/pull/279) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Moved the docker run command to a separate file in /usr/local/bin and… [\#278](https://github.com/puppetlabs/puppetlabs-docker/pull/278) ([dploeger](https://github.com/dploeger))
- Update README.md [\#277](https://github.com/puppetlabs/puppetlabs-docker/pull/277) ([davejrt](https://github.com/davejrt))
- Update readme for networks and swarm on windows [\#276](https://github.com/puppetlabs/puppetlabs-docker/pull/276) ([florindragos](https://github.com/florindragos))
- Fixes acceptance tests on linux for latest docker version  [\#275](https://github.com/puppetlabs/puppetlabs-docker/pull/275) ([davejrt](https://github.com/davejrt))
- Run docker services on windows [\#274](https://github.com/puppetlabs/puppetlabs-docker/pull/274) ([florindragos](https://github.com/florindragos))
- CLOUD-2011 - update readme for Windows Support [\#273](https://github.com/puppetlabs/puppetlabs-docker/pull/273) ([mihaibuzgau](https://github.com/mihaibuzgau))
- fix for restart\_check on windows [\#271](https://github.com/puppetlabs/puppetlabs-docker/pull/271) ([mihaibuzgau](https://github.com/mihaibuzgau))
- fixing healthcheck WIP [\#270](https://github.com/puppetlabs/puppetlabs-docker/pull/270) ([davejrt](https://github.com/davejrt))
- adding in acceptance test for storage driver [\#269](https://github.com/puppetlabs/puppetlabs-docker/pull/269) ([davejrt](https://github.com/davejrt))
- 1.2.0 [\#268](https://github.com/puppetlabs/puppetlabs-docker/pull/268) ([davejrt](https://github.com/davejrt))
- testing windows healthcheck cmd [\#267](https://github.com/puppetlabs/puppetlabs-docker/pull/267) ([davejrt](https://github.com/davejrt))
- Support private docker registries on windows [\#266](https://github.com/puppetlabs/puppetlabs-docker/pull/266) ([florindragos](https://github.com/florindragos))
- fixes fact for windows [\#264](https://github.com/puppetlabs/puppetlabs-docker/pull/264) ([davejrt](https://github.com/davejrt))
- Cloud 1900 [\#263](https://github.com/puppetlabs/puppetlabs-docker/pull/263) ([davejrt](https://github.com/davejrt))
- Configure Docker Swarm on Windows [\#262](https://github.com/puppetlabs/puppetlabs-docker/pull/262) ([florindragos](https://github.com/florindragos))
- CLOUD-1967-Fixing -Docker\_stacks-image resolve [\#261](https://github.com/puppetlabs/puppetlabs-docker/pull/261) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- adding in example for docker store [\#258](https://github.com/puppetlabs/puppetlabs-docker/pull/258) ([davejrt](https://github.com/davejrt))
- \(CLOUD-1850\)-Restart docker container on unhealthy status [\#254](https://github.com/puppetlabs/puppetlabs-docker/pull/254) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Volumes acceptance test for Docker on Windows [\#253](https://github.com/puppetlabs/puppetlabs-docker/pull/253) ([mihaibuzgau](https://github.com/mihaibuzgau))
- Run docker compose on windows [\#252](https://github.com/puppetlabs/puppetlabs-docker/pull/252) ([florindragos](https://github.com/florindragos))
- Add docker exec functionality for Docker on Windows [\#251](https://github.com/puppetlabs/puppetlabs-docker/pull/251) ([mihaibuzgau](https://github.com/mihaibuzgau))
- add docker run tests for Windows [\#249](https://github.com/puppetlabs/puppetlabs-docker/pull/249) ([mihaibuzgau](https://github.com/mihaibuzgau))
- CLOUD-1854-Fixing github issue \#213 [\#247](https://github.com/puppetlabs/puppetlabs-docker/pull/247) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Add integration tests for Docker on Windows using vmpooler [\#246](https://github.com/puppetlabs/puppetlabs-docker/pull/246) ([mihaibuzgau](https://github.com/mihaibuzgau))
- Docker run on windows [\#242](https://github.com/puppetlabs/puppetlabs-docker/pull/242) ([florindragos](https://github.com/florindragos))
- make Windows Docker deployment idempotent [\#240](https://github.com/puppetlabs/puppetlabs-docker/pull/240) ([mihaibuzgau](https://github.com/mihaibuzgau))
- fix "start a container with cpuset" acceptance test on ubuntu1404 [\#236](https://github.com/puppetlabs/puppetlabs-docker/pull/236) ([mihaibuzgau](https://github.com/mihaibuzgau))
- changing docker spec to alpine due to issue with init on ubuntu [\#235](https://github.com/puppetlabs/puppetlabs-docker/pull/235) ([davejrt](https://github.com/davejrt))
- Fix dependency cycle issue [\#233](https://github.com/puppetlabs/puppetlabs-docker/pull/233) ([rvdh](https://github.com/rvdh))
- docker::stack unless and onlyif were doing "docker stack deploy ls" [\#231](https://github.com/puppetlabs/puppetlabs-docker/pull/231) ([hdeadman](https://github.com/hdeadman))
- Update install.pp to Support Red Hat "yum" Package Provider [\#227](https://github.com/puppetlabs/puppetlabs-docker/pull/227) ([jmbelvar81](https://github.com/jmbelvar81))
- Add Docker EE support for Windows Server 2016 [\#222](https://github.com/puppetlabs/puppetlabs-docker/pull/222) ([mihaibuzgau](https://github.com/mihaibuzgau))
- Fix incompatiblity with puppet4 [\#221](https://github.com/puppetlabs/puppetlabs-docker/pull/221) ([TheBigLee](https://github.com/TheBigLee))
- Repair syntax error in Readme [\#220](https://github.com/puppetlabs/puppetlabs-docker/pull/220) ([lokal-profil](https://github.com/lokal-profil))
- adding in the functionality to define swarm clusters in hiera [\#219](https://github.com/puppetlabs/puppetlabs-docker/pull/219) ([davejrt](https://github.com/davejrt))
- fix for \#208 [\#210](https://github.com/puppetlabs/puppetlabs-docker/pull/210) ([scotty-c](https://github.com/scotty-c))
- unlocking puppet version for travis [\#205](https://github.com/puppetlabs/puppetlabs-docker/pull/205) ([davejrt](https://github.com/davejrt))
- Readme volume [\#204](https://github.com/puppetlabs/puppetlabs-docker/pull/204) ([davejrt](https://github.com/davejrt))
- Add support for onlyif in a docker exec [\#202](https://github.com/puppetlabs/puppetlabs-docker/pull/202) ([electrofelix](https://github.com/electrofelix))
- Support refreshonly flag [\#201](https://github.com/puppetlabs/puppetlabs-docker/pull/201) ([electrofelix](https://github.com/electrofelix))
- Use line breaks and continuation for run flags [\#200](https://github.com/puppetlabs/puppetlabs-docker/pull/200) ([electrofelix](https://github.com/electrofelix))
- Limit Image -\> Run dependencies to those used [\#199](https://github.com/puppetlabs/puppetlabs-docker/pull/199) ([electrofelix](https://github.com/electrofelix))
- 1.1.0 [\#196](https://github.com/puppetlabs/puppetlabs-docker/pull/196) ([davejrt](https://github.com/davejrt))

## [1.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/1.1.0) (2018-03-15)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/e1.1...1.1.0)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- CLOUD-1775 Minor Readme edits [\#195](https://github.com/puppetlabs/puppetlabs-docker/pull/195) ([EamonnTP](https://github.com/EamonnTP))
- Close placeholders in README [\#194](https://github.com/puppetlabs/puppetlabs-docker/pull/194) ([johnmccabe](https://github.com/johnmccabe))
- \(maint\)CLOUD-1768 - Adding acceptance test for cpuset flag [\#191](https://github.com/puppetlabs/puppetlabs-docker/pull/191) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- adding in issue template [\#190](https://github.com/puppetlabs/puppetlabs-docker/pull/190) ([davejrt](https://github.com/davejrt))
- Update README.md [\#188](https://github.com/puppetlabs/puppetlabs-docker/pull/188) ([davejrt](https://github.com/davejrt))
- \(maint\)CLOUD-1768 Fixing incorrect cpuset flag \#183 [\#187](https://github.com/puppetlabs/puppetlabs-docker/pull/187) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Move the image parameter to the end [\#186](https://github.com/puppetlabs/puppetlabs-docker/pull/186) ([alikashmar](https://github.com/alikashmar))
- CLOUD-1637 Readme update [\#185](https://github.com/puppetlabs/puppetlabs-docker/pull/185) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- supported\_os\_fix [\#184](https://github.com/puppetlabs/puppetlabs-docker/pull/184) ([davejrt](https://github.com/davejrt))
- Docker login Receipt is now removed if login fails and added acceptance tests [\#182](https://github.com/puppetlabs/puppetlabs-docker/pull/182) ([sigsegv11](https://github.com/sigsegv11))
- Cloud 1654 [\#181](https://github.com/puppetlabs/puppetlabs-docker/pull/181) ([davejrt](https://github.com/davejrt))
- Cloud 1719 [\#180](https://github.com/puppetlabs/puppetlabs-docker/pull/180) ([davejrt](https://github.com/davejrt))
- Fix debian systemd [\#177](https://github.com/puppetlabs/puppetlabs-docker/pull/177) ([damoun](https://github.com/damoun))
- fixing deletion of debian logic [\#176](https://github.com/puppetlabs/puppetlabs-docker/pull/176) ([davejrt](https://github.com/davejrt))
- Cloud 1750 [\#175](https://github.com/puppetlabs/puppetlabs-docker/pull/175) ([davejrt](https://github.com/davejrt))
- Update README.md [\#174](https://github.com/puppetlabs/puppetlabs-docker/pull/174) ([davejrt](https://github.com/davejrt))
- Added option to pass a Dockerfile to $docker\_dir [\#171](https://github.com/puppetlabs/puppetlabs-docker/pull/171) ([genebean](https://github.com/genebean))
- Use RHSM Repo ID as the default for the extras repo name on RHEL7 [\#168](https://github.com/puppetlabs/puppetlabs-docker/pull/168) ([nikdoof](https://github.com/nikdoof))
- confining docker fact to 1.13 and later [\#166](https://github.com/puppetlabs/puppetlabs-docker/pull/166) ([davejrt](https://github.com/davejrt))
- Update stack.rb [\#164](https://github.com/puppetlabs/puppetlabs-docker/pull/164) ([davejrt](https://github.com/davejrt))
- Use `-o` option when downloading docker compose [\#162](https://github.com/puppetlabs/puppetlabs-docker/pull/162) ([alexjfisher](https://github.com/alexjfisher))
- Add registry\_mirror parameter to services to match services flag function [\#160](https://github.com/puppetlabs/puppetlabs-docker/pull/160) ([esalberg](https://github.com/esalberg))
- Readme.md patch [\#158](https://github.com/puppetlabs/puppetlabs-docker/pull/158) ([davejrt](https://github.com/davejrt))
- Fixing typo that breaks docker-compose file version matching and enab… [\#157](https://github.com/puppetlabs/puppetlabs-docker/pull/157) ([sigsegv11](https://github.com/sigsegv11))
- Add new parameter 'read\_only' to ::docker::run [\#154](https://github.com/puppetlabs/puppetlabs-docker/pull/154) ([jacksgt](https://github.com/jacksgt))
- \(Enabling rubocop and lint on docker\) [\#150](https://github.com/puppetlabs/puppetlabs-docker/pull/150) ([sheenaajay](https://github.com/sheenaajay))
- fix typo [\#149](https://github.com/puppetlabs/puppetlabs-docker/pull/149) ([seriv](https://github.com/seriv))
- locking gem to stop upstream stdlib error [\#147](https://github.com/puppetlabs/puppetlabs-docker/pull/147) ([davejrt](https://github.com/davejrt))
- Add more supported params to run example [\#146](https://github.com/puppetlabs/puppetlabs-docker/pull/146) ([w4tsn](https://github.com/w4tsn))
- \(fix for \#143 and \#144\) [\#145](https://github.com/puppetlabs/puppetlabs-docker/pull/145) ([sheenaajay](https://github.com/sheenaajay))
- Fix hiera examples [\#142](https://github.com/puppetlabs/puppetlabs-docker/pull/142) ([dol](https://github.com/dol))
- Fix trivial README typo [\#136](https://github.com/puppetlabs/puppetlabs-docker/pull/136) ([alexjfisher](https://github.com/alexjfisher))
- setting sane defaults for socket group on RedHat systems [\#134](https://github.com/puppetlabs/puppetlabs-docker/pull/134) ([davejrt](https://github.com/davejrt))
- preparing for release [\#132](https://github.com/puppetlabs/puppetlabs-docker/pull/132) ([davejrt](https://github.com/davejrt))
- Fix typo [\#130](https://github.com/puppetlabs/puppetlabs-docker/pull/130) ([shamil](https://github.com/shamil))
- Cloud 1528 [\#129](https://github.com/puppetlabs/puppetlabs-docker/pull/129) ([davejrt](https://github.com/davejrt))
- \(CLOUD-1673\) Remove epel dependecny in docker [\#127](https://github.com/puppetlabs/puppetlabs-docker/pull/127) ([sheenaajay](https://github.com/sheenaajay))
- docker::compose proxy accepts http proxy [\#126](https://github.com/puppetlabs/puppetlabs-docker/pull/126) ([BobVanB](https://github.com/BobVanB))
- Fix systemd escaping issue \#124 [\#125](https://github.com/puppetlabs/puppetlabs-docker/pull/125) ([olivierHa](https://github.com/olivierHa))
- changing variable name due to facter bug [\#123](https://github.com/puppetlabs/puppetlabs-docker/pull/123) ([davejrt](https://github.com/davejrt))
- replace Tuple with Array\[String\] [\#121](https://github.com/puppetlabs/puppetlabs-docker/pull/121) ([lobeck](https://github.com/lobeck))
- \(CLOUD-1661\) Fixing rubocop error andaddingi18ngem [\#120](https://github.com/puppetlabs/puppetlabs-docker/pull/120) ([sheenaajay](https://github.com/sheenaajay))
- removing manage\_kernel [\#116](https://github.com/puppetlabs/puppetlabs-docker/pull/116) ([davejrt](https://github.com/davejrt))
- Repo fix arch [\#115](https://github.com/puppetlabs/puppetlabs-docker/pull/115) ([davejrt](https://github.com/davejrt))
- stubbing processor fact to fix failures on osx [\#112](https://github.com/puppetlabs/puppetlabs-docker/pull/112) ([davejrt](https://github.com/davejrt))
- Add resource type and provider for docker\_volumes [\#111](https://github.com/puppetlabs/puppetlabs-docker/pull/111) ([dhollinger](https://github.com/dhollinger))
- \(CLOUD-1663\) update the apt module to the latest [\#110](https://github.com/puppetlabs/puppetlabs-docker/pull/110) ([sheenaajay](https://github.com/sheenaajay))
- CLOUD-1610 Adding registry mirror flag [\#109](https://github.com/puppetlabs/puppetlabs-docker/pull/109) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Socket group [\#107](https://github.com/puppetlabs/puppetlabs-docker/pull/107) ([davejrt](https://github.com/davejrt))
- Spec fix [\#105](https://github.com/puppetlabs/puppetlabs-docker/pull/105) ([davejrt](https://github.com/davejrt))
- Add facts from docker version and docker info. [\#103](https://github.com/puppetlabs/puppetlabs-docker/pull/103) ([mterzo](https://github.com/mterzo))
- remove docker\_cs param docs [\#101](https://github.com/puppetlabs/puppetlabs-docker/pull/101) ([LongLiveCHIEF](https://github.com/LongLiveCHIEF))
- \(CLOUD\_1505\) validate functions [\#99](https://github.com/puppetlabs/puppetlabs-docker/pull/99) ([sheenaajay](https://github.com/sheenaajay))
- docker::registry fixes [\#97](https://github.com/puppetlabs/puppetlabs-docker/pull/97) ([shamil](https://github.com/shamil))
- 1.0.4 [\#96](https://github.com/puppetlabs/puppetlabs-docker/pull/96) ([davejrt](https://github.com/davejrt))

## [e1.1](https://github.com/puppetlabs/puppetlabs-docker/tree/e1.1) (2018-02-15)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.5...e1.1)

## [1.0.5](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.5) (2018-01-30)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.4...1.0.5)

## [1.0.4](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.4) (2018-01-03)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.3...1.0.4)

## [1.0.3](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.3) (2018-01-02)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/e1.0...1.0.3)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- Allow setting commented TMPDIR in systemd file for backwards compatibility [\#90](https://github.com/puppetlabs/puppetlabs-docker/pull/90) ([esalberg](https://github.com/esalberg))

## [e1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/e1.0) (2017-12-21)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.2...e1.0)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- Adding \. to regex on init.pp:540 to address issue \#84 [\#85](https://github.com/puppetlabs/puppetlabs-docker/pull/85) ([dmcanally](https://github.com/dmcanally))
- gpg check optional [\#82](https://github.com/puppetlabs/puppetlabs-docker/pull/82) ([alvarolmedo](https://github.com/alvarolmedo))
- Forcing pull when tag is latest [\#81](https://github.com/puppetlabs/puppetlabs-docker/pull/81) ([alvarolmedo](https://github.com/alvarolmedo))
- fixing regex for older versions [\#80](https://github.com/puppetlabs/puppetlabs-docker/pull/80) ([davejrt](https://github.com/davejrt))
- \(maint\)updating readme for github issue \#68 [\#79](https://github.com/puppetlabs/puppetlabs-docker/pull/79) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- issue 77 - Removes unused variable. [\#78](https://github.com/puppetlabs/puppetlabs-docker/pull/78) ([mpepping](https://github.com/mpepping))
- \(maint\)Fixing syntax error to get ci passing [\#76](https://github.com/puppetlabs/puppetlabs-docker/pull/76) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Fixed docker-compose issues. \#74 [\#75](https://github.com/puppetlabs/puppetlabs-docker/pull/75) ([pezzak](https://github.com/pezzak))
- Add support for overlay2.override\_kernel\_check setting [\#71](https://github.com/puppetlabs/puppetlabs-docker/pull/71) ([gdubicki](https://github.com/gdubicki))
- update docs for using legacy package [\#69](https://github.com/puppetlabs/puppetlabs-docker/pull/69) ([alexcreek](https://github.com/alexcreek))
- Add Docker Fact [\#65](https://github.com/puppetlabs/puppetlabs-docker/pull/65) ([cdenneen](https://github.com/cdenneen))
- Allow skipping usage of pw\_hash [\#63](https://github.com/puppetlabs/puppetlabs-docker/pull/63) ([jeefberkey](https://github.com/jeefberkey))
- \(CLOUD-1560\)-adding-functionality to remove systemd service files. [\#61](https://github.com/puppetlabs/puppetlabs-docker/pull/61) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Additional flags for creating a network [\#60](https://github.com/puppetlabs/puppetlabs-docker/pull/60) ([coder-hugo](https://github.com/coder-hugo))
- fixing incorrect repo url for redhat [\#59](https://github.com/puppetlabs/puppetlabs-docker/pull/59) ([davejrt](https://github.com/davejrt))
- fixing commented out tmpdir [\#58](https://github.com/puppetlabs/puppetlabs-docker/pull/58) ([davejrt](https://github.com/davejrt))
- Allow multiple label and env parameters on services [\#55](https://github.com/puppetlabs/puppetlabs-docker/pull/55) ([guimaluf](https://github.com/guimaluf))
- Allow multiple docker::services declarations [\#54](https://github.com/puppetlabs/puppetlabs-docker/pull/54) ([guimaluf](https://github.com/guimaluf))
- Allow multiple docker::secrets declarations [\#52](https://github.com/puppetlabs/puppetlabs-docker/pull/52) ([guimaluf](https://github.com/guimaluf))
- Fix for Issue \#43 [\#48](https://github.com/puppetlabs/puppetlabs-docker/pull/48) ([RXM307](https://github.com/RXM307))

## [1.0.2](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.2) (2017-11-17)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.1...1.0.2)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- release prep 1.0.2 [\#47](https://github.com/puppetlabs/puppetlabs-docker/pull/47) ([scotty-c](https://github.com/scotty-c))
- Cloud 1469 [\#46](https://github.com/puppetlabs/puppetlabs-docker/pull/46) ([davejrt](https://github.com/davejrt))
- repos.pp: use ensure\_packages instead of package resource [\#41](https://github.com/puppetlabs/puppetlabs-docker/pull/41) ([hex2a](https://github.com/hex2a))
- adding in logic to make docker::registry idempodent [\#40](https://github.com/puppetlabs/puppetlabs-docker/pull/40) ([davejrt](https://github.com/davejrt))
- fixing yumrepo gpg url [\#37](https://github.com/puppetlabs/puppetlabs-docker/pull/37) ([davejrt](https://github.com/davejrt))
- fixing issue \#21 [\#36](https://github.com/puppetlabs/puppetlabs-docker/pull/36) ([davejrt](https://github.com/davejrt))
- Allow all digits \(IP\) for proxy URL [\#35](https://github.com/puppetlabs/puppetlabs-docker/pull/35) ([ianssoftcom](https://github.com/ianssoftcom))
- \(maint\) Adding rspec\_junit\_formatter [\#34](https://github.com/puppetlabs/puppetlabs-docker/pull/34) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- \(maint\)updating arrow alignment for puppet language style guide [\#32](https://github.com/puppetlabs/puppetlabs-docker/pull/32) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Cloud 1524 [\#31](https://github.com/puppetlabs/puppetlabs-docker/pull/31) ([davejrt](https://github.com/davejrt))
- allow configuration of gem sources [\#29](https://github.com/puppetlabs/puppetlabs-docker/pull/29) ([LongLiveCHIEF](https://github.com/LongLiveCHIEF))
- refactor inclusion of sub-classes [\#28](https://github.com/puppetlabs/puppetlabs-docker/pull/28) ([LongLiveCHIEF](https://github.com/LongLiveCHIEF))
- adding in support for puppet 5 [\#27](https://github.com/puppetlabs/puppetlabs-docker/pull/27) ([davejrt](https://github.com/davejrt))
- fixing unit tests [\#25](https://github.com/puppetlabs/puppetlabs-docker/pull/25) ([davejrt](https://github.com/davejrt))
- \(maint\)fixing syntax error in compose spec file [\#23](https://github.com/puppetlabs/puppetlabs-docker/pull/23) ([MWilsonPuppet](https://github.com/MWilsonPuppet))
- Updating proxy to allow for username and password to be passed. [\#22](https://github.com/puppetlabs/puppetlabs-docker/pull/22) ([dforste](https://github.com/dforste))

## [1.0.1](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.1) (2017-10-15)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/1.0.0...1.0.1)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- Release Prep for 1.0.1 [\#19](https://github.com/puppetlabs/puppetlabs-docker/pull/19) ([gregohardy](https://github.com/gregohardy))
- Abstracted service\_name for docker-run.erb template [\#17](https://github.com/puppetlabs/puppetlabs-docker/pull/17) ([robert4man](https://github.com/robert4man))
- Update README.md [\#13](https://github.com/puppetlabs/puppetlabs-docker/pull/13) ([kgeis](https://github.com/kgeis))

## [1.0.0](https://github.com/puppetlabs/puppetlabs-docker/tree/1.0.0) (2017-10-11)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/947a1f158444b4b9434dab3ccfa1306f885a67eb...1.0.0)

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- Readme edits. [\#8](https://github.com/puppetlabs/puppetlabs-docker/pull/8) ([EamonnTP](https://github.com/EamonnTP))
- \(CLOUD-1439\) Readme edits [\#7](https://github.com/puppetlabs/puppetlabs-docker/pull/7) ([EamonnTP](https://github.com/EamonnTP))
- Adding stacks [\#6](https://github.com/puppetlabs/puppetlabs-docker/pull/6) ([scotty-c](https://github.com/scotty-c))
- adding in contributors from forked module [\#5](https://github.com/puppetlabs/puppetlabs-docker/pull/5) ([davejrt](https://github.com/davejrt))
- adding in fix for new apt module and updating metadata.json [\#4](https://github.com/puppetlabs/puppetlabs-docker/pull/4) ([davejrt](https://github.com/davejrt))
- adding in docker secrets [\#3](https://github.com/puppetlabs/puppetlabs-docker/pull/3) ([davejrt](https://github.com/davejrt))
- Cloud 1375 [\#2](https://github.com/puppetlabs/puppetlabs-docker/pull/2) ([davejrt](https://github.com/davejrt))
- Merging personal testing fork into puppetlabs feature branch [\#1](https://github.com/puppetlabs/puppetlabs-docker/pull/1) ([davejrt](https://github.com/davejrt))

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
