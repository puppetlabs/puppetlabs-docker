# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-docker/tree/v6.1.0) (2023-04-28)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v6.0.2...v6.1.0)

### Added

- \(CONT-351\) Syntax update [\#901](https://github.com/puppetlabs/puppetlabs-docker/pull/901) ([LukasAud](https://github.com/LukasAud))

### Fixed

- Fix `docker` fact with recent version of docker [\#897](https://github.com/puppetlabs/puppetlabs-docker/pull/897) ([smortex](https://github.com/smortex))

### UNCATEGORIZED PRS; LABEL THEM ON GITHUB

- Use puppet yaml helper to workaround psych \>4 breaking changes  [\#877](https://github.com/puppetlabs/puppetlabs-docker/pull/877) ([gfargeas](https://github.com/gfargeas))

## [v6.0.2](https://github.com/puppetlabs/puppetlabs-docker/tree/v6.0.2) (2022-12-08)

[Full Changelog](https://github.com/puppetlabs/puppetlabs-docker/compare/v6.0.1...v6.0.2)

### Fixed

- \(CONT-24\) docker\_stack always redoploying [\#878](https://github.com/puppetlabs/puppetlabs-docker/pull/878) ([david22swan](https://github.com/david22swan))

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
- Change `stop\_wait\_time` value to match Docker default [\#858](https://github.com/puppetlabs/puppetlabs-docker/pull/858) ([sebcdri](https://github.com/sebcdri))

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
- Fix \#239 local\_user permission denied [\#497](https://github.com/puppetlabs/puppetlabs-docker/pull/497) ([thde](https://github.com/thde))

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
