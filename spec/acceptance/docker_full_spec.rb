# frozen_string_literal: true

require 'spec_helper_acceptance'

if os[:kernel] == 'windows'
  docker_args = 'docker_ee => true'
  default_image = 'winamd64/hello-seattle'
  default_image_tag = if os[:release][:major] == '2019' || os[:release][:major] == '2022'
                        'nanoserver'
                      else
                        'nanoserver-sac2016'
                      end
  default_digest = 'sha256:dcba85354678b50608b8c40ec6d17cce063a224aa0e12b6a55dc47b67f039e75'
  default_local_digest = 'sha256:8421d9a84432575381bfabd248f1eb56f3aa21d9d7cd2511583c68c9b7511d10'
  second_image = 'winamd64/hola-mundo'
  default_dockerfile = 'C:/Users/Administrator/AppData/Local/Temp/Dockerfile'
  dockerfile_test = 'C:/Windows/Dockerfile_test.txt'
  # The default args are set because:
  # restart => 'always' - there is no service created to manage containers
  # net => 'nat' - docker uses bridged by default when running a container. When installing docker on windows the default network is NAT.
  default_docker_run_arg = "restart => 'always', net => 'nat',"
  default_run_command = 'ping 127.0.0.1 -t'
  docker_command = '"/cygdrive/c/Program Files/Docker/docker"'
  default_docker_exec_lr_command = 'cmd /c "ping 127.0.0.1 -t > C:\Users\Public\test_file.txt"'
  default_docker_exec_command = 'cmd /c "echo test > C:\Users\Public\test_file.txt"'
  docker_mount_path = 'C:/Users/Public/DockerVolume'
  storage_driver = 'windowsfilter'
else
  docker_args = ''
  default_image = 'alpine'
  second_image = 'busybox'
  default_image_tag = '3.7'
  default_digest = 'sha256:3dcdb92d7432d56604d4545cbd324b14e647b313626d99b889d0626de158f73a'
  default_local_digest = 'sha256:8421d9a84432575381bfabd248f1eb56f3aa21d9d7cd2511583c68c9b7511d10'
  default_dockerfile = '/root/Dockerfile'
  dockerfile_test = "#{default_dockerfile}_test.txt"
  docker_command = 'docker'
  default_docker_run_arg = ''
  default_run_command = 'init'
  default_docker_exec_lr_command = '/bin/sh -c "touch /root/test_file.txt; while true; do echo hello world; sleep 1; done"'
  default_docker_exec_command = 'touch /root/test_file.txt'
  docker_mount_path = '/root'
  storage_driver = 'devicemapper'
  storage_driver = if os[:family] == 'RedHat'
                     'devicemapper'
                   else
                     'overlay2'
                   end
end

describe 'the Puppet Docker module' do
  context 'clean up before each test', win_broken: true do
    before(:each) do
      retry_on_error_matching(60, 5, %r{connection failure running}) do
        # Stop all container using systemd
        run_shell('ls -D -1 /etc/systemd/system/docker-container* | sed \'s/\/etc\/systemd\/system\///g\' | sed \'s/\.service//g\' | while read container; do service $container stop; done')
        # Delete all running containers
        run_shell("#{docker_command} rm -f $(#{docker_command} ps -a -q) || true")
        # Delete all existing images
        run_shell("#{docker_command} rmi -f $(#{docker_command} images -q) || true")
        # Check to make sure no images are present
        run_shell("#{docker_command} images | wc -l") do |r|
          expect(r.stdout).to match(%r{^0|1$})
        end
        # Check to make sure no running containers are present
        run_shell("#{docker_command} ps | wc -l") do |r|
          expect(r.stdout).to match(%r{^0|1$})
        end
      end
    end

    describe 'docker class' do
      context 'without any parameters', win_broken: true do
        let(:pp) { "class { 'docker': #{docker_args} }" }

        it 'runs successfully' do
          apply_manifest(pp, catch_failures: true)
        end

        it 'runs idempotently' do
          apply_manifest(pp, catch_changes: true) unless selinux == 'true'
        end

        it 'is start a docker process' do
          if os[:family] == 'windows'
            run_shell('powershell Get-Process -Name dockerd') do |r|
              expect(r.stdout).to match(%r{ProcessName})
            end
          else
            run_shell('ps aux | grep docker') do |r|
              expect(r.stdout).to match(%r{dockerd -H unix:\/\/\/var\/run\/docker.sock})
            end
          end
        end

        it 'installs a working docker client' do
          run_shell("#{docker_command} ps", expect_failures: false)
        end

        it 'stops a running container and remove container' do
          pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_6':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

          pp2 = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_6':
            ensure  => 'absent',
            image   => '#{default_image}',
            require => Docker::Image['#{default_image}'],
          }
        EOS

          apply_manifest(pp, catch_failures: true)
          apply_manifest(pp, catch_changes: true) unless selinux == 'true'

          # A sleep to give docker time to execute properly
          sleep 15

          run_shell("#{docker_command} ps", expect_failures: false)

          apply_manifest(pp2, catch_failures: true)
          apply_manifest(pp2, catch_changes: true) unless selinux == 'true'

          # A sleep to give docker time to execute properly
          sleep 15

          run_shell("#{docker_command} inspect container-3-6", expect_failures: true)
          if os[:family] == 'windows'
            run_shell('test -f /cygdrive/c/Users/Administrator/AppData/Local/Temp/container-3-6.service', expect_failures: true)
          else
            run_shell('test -f /etc/systemd/system/container-3-6.service', expect_failures: true)
          end
        end
      end

      context 'passing a storage driver' do
        let(:pp) do
          <<-MANIFEST
            class {'docker':
              #{docker_args},
              storage_driver => "#{storage_driver}",
            }
          MANIFEST
        end

        it 'applies manifest' do
          apply_manifest(pp, catch_failures: true)
          sleep 15
        end

        it 'results in the docker daemon being configured with the specified storage driver' do
          run_shell("#{docker_command} info -f \"{{ .Driver}}\"") do |r|
            expect(r.stdout).to match %r{#{storage_driver}}
          end
        end
      end

      context 'passing a TCP address to bind to' do
        let(:pp) do
          <<-MANIFEST
            class { 'docker':
              tcp_bind => 'tcp://127.0.0.1:4444',
              #{docker_args}
            }
          MANIFEST
        end

        it 'runs idempotently' do
          idempotent_apply(pp) unless selinux == 'true'
          sleep 4
        end

        it 'results in docker listening on the specified address' do
          if os[:family] == 'windows'
            run_shell('netstat -a -b') do |r|
              expect(r.stdout).to match(%r{127.0.0.1:4444})
            end
          else
            run_shell('netstat -tulpn | grep docker') do |r|
              expect(r.stdout).to match(%r{tcp\s+0\s+0\s+127.0.0.1:4444\s+0.0.0.0\:\*\s+LISTEN\s+\d+\/docker})
            end
          end
        end
      end

      context 'bound to a particular unix socket' do
        let(:pp) do
          <<-MANIFEST
            class { 'docker':
              socket_bind => 'unix:///var/run/docker.sock',
              #{docker_args}
            }
          MANIFEST
        end

        it 'runs idempotently' do
          idempotent_apply(pp) unless selinux == 'true'
          sleep 4
        end

        it 'shows docker listening on the specified unix socket' do
          if os[:family] != 'windows'
            run_shell('ps aux | grep docker') do |r|
              expect(r.stdout).to match(%r{unix:\/\/\/var\/run\/docker.sock})
            end
          end
        end
      end

      context 'uninstall docker' do
        after(:all) do
          pp = <<-EOS
            class {'docker': #{docker_args},
              ensure => 'present'
            }
          EOS
          apply_manifest(pp, catch_failures: true)

          # Wait for reboot if windows
          sleep 300 if os[:family] == 'windows'
        end

        it 'uninstalls successfully' do
          pp = <<-EOS
            class {'docker': #{docker_args},
              ensure => 'absent'
            }
          EOS
          apply_manifest(pp, catch_failures: true)
          sleep 4
          run_shell('docker ps', expect_failures: true)
        end
      end
    end

    describe 'docker::image' do
      it 'successfullies download an image from the Docker Hub' do
        pp = <<-EOS
          class { 'docker': #{docker_args} }
          docker::image { '#{default_image}':
            ensure  => present,
            require => Class['docker'],
          }
        EOS
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        run_shell("#{docker_command} images") do |r|
          expect(r.stdout).to match(%r{#{default_image}})
        end
      end

      it 'successfullies download an image based on a tag from the Docker Hub' do
        pp = <<-EOS
          class { 'docker': #{docker_args} }
          docker::image { '#{default_image}':
            ensure    => present,
            image_tag => '#{default_image_tag}',
            require   => Class['docker'],
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        run_shell("#{docker_command} images") do |r|
          expect(r.stdout).to match(%r{#{default_image}\s+#{default_image_tag}})
        end
      end

      it 'successfullies download an image based on a digest from the Docker Hub' do
        pp = <<-EOS
          class { 'docker': #{docker_args} }
          docker::image { '#{default_image}':
            ensure       => present,
            image_digest => '#{default_digest}',
            require      => Class['docker'],
          }
        EOS
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        run_shell("#{docker_command} images --digests") do |r|
          expect(r.stdout).to match(%r{#{default_image}.*#{default_digest}})
        end
      end

      it 'creates a new image based on a Dockerfile' do
        run_cmd = if os[:family] == 'windows'
                    'RUN echo test > C:\\Users\\Public\\Dockerfile_test.txt'
                  else
                    "RUN echo test > #{dockerfile_test}"
                  end

        pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { 'alpine_with_file':
            docker_file => "#{default_dockerfile}",
            require     => Class['docker'],
          }

          file { '#{default_dockerfile}':
            ensure  => present,
            content => "FROM #{default_image}\n#{run_cmd}",
            before  => Docker::Image['alpine_with_file'],
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4
        if os[:family] == 'windows'
          run_shell("#{docker_command} run alpine_with_file cmd /c dir Users\\\\Public") do |r|
            expect(r.stdout).to match(%r{_test.txt})
          end
        else
          run_shell("#{docker_command} run alpine_with_file ls #{dockerfile_test}") do |r|
            expect(r.stdout).to match(%r{#{dockerfile_test}})
          end
        end
      end

      it 'creates a new image based on a tar', win_broken: true do
        pp = <<-EOS
          class { 'docker': #{docker_args} }
          docker::image { '#{default_image}':
            require => Class['docker'],
            ensure  => present,
          }

          docker::run { 'container_2_4':
            image   => '#{default_image}',
            command => '/bin/sh -c "touch /root/test_file_for_tar_test.txt; while true; do echo hello world; sleep 1; done"',
            require => Docker::Image['alpine'],
          }
        EOS

        pp2 = <<-EOS
          class { 'docker': #{docker_args} }
          docker::image { 'alpine_from_commit':
            docker_tar => "/root/rootfs.tar"
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        # Commit currently running container as an image
        container_id = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $1}'")
        run_shell("#{docker_command} commit #{container_id.stdout.strip} alpine_from_commit")

        # Stop all container using systemd
        run_shell('ls -D -1 /etc/systemd/system/docker-container* | sed \'s/\/etc\/systemd\/system\///g\' | sed \'s/\.service//g\' | while read container; do service $container stop; done')

        # Stop all running containers
        run_shell("#{docker_command} rm -f $(docker ps -a -q) || true")

        # Make sure no other containers are running
        run_shell("#{docker_command} ps | wc -l") do |r|
          expect(r.stdout).to match(%r{^1$})
        end

        # Export new to a tar file
        run_shell("#{docker_command} save alpine_from_commit > /root/rootfs.tar")

        # Remove all images
        run_shell("#{docker_command} rmi $(docker images -q) || true")

        # Make sure no other images are present
        run_shell("#{docker_command} images | wc -l") do |r|
          expect(r.stdout).to match(%r{^1$})
        end

        apply_manifest(pp2, catch_failures: true)
        apply_manifest(pp2, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        run_shell("#{docker_command} run alpine_from_commit ls /root") do |r|
          expect(r.stdout).to match(%r{test_file_for_tar_test.txt})
        end
      end

      it 'successfullies delete the image' do
        pp1 = <<-EOS
          class { 'docker': #{docker_args} }
          docker::image { '#{default_image}':
            ensure  => present,
            require => Class['docker'],
          }
        EOS
        apply_manifest(pp1, catch_failures: true)
        pp2 = <<-EOS
          class { 'docker': #{docker_args} }
          docker::image { '#{default_image}':
            ensure => absent,
          }
        EOS
        apply_manifest(pp2, catch_failures: true)
        apply_manifest(pp2, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        run_shell("#{docker_command} images") do |r|
          expect(r.stdout).not_to match(%r{#{default_image}})
        end
      end
    end

    describe 'docker::run' do
      it 'starts a container with a configurable command' do
        pp = <<-EOS
          class { 'docker': #{docker_args}
          }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_1':
            image   => '#{default_image}',
            command => '#{default_docker_exec_lr_command}',
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        container_id = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $1}'")
        if os[:family] == 'windows'
          run_shell("#{docker_command} exec #{container_id.stdout.strip} cmd /c dir Users\\\\Public") do |r|
            expect(r.stdout).to match(%r{test_file.txt})
          end
        else
          run_shell("#{docker_command} exec #{container_id.stdout.strip} ls /root") do |r|
            expect(r.stdout).to match(%r{test_file.txt})
          end
        end

        container_name = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $NF}'")
        expect(container_name.stdout.strip.to_s).to match(%r{(container-3-1|container_3_1)})
      end

      it 'starts a container with port configuration' do
        pp = <<-EOS
          class { 'docker': #{docker_args}}

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_2':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            ports   => ['4444'],
            expose  => ['5555'],
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        run_shell("#{docker_command} ps") do |r|
          expect(r.stdout).to match(%r{#{default_run_command}.+5555\/tcp\, 0\.0\.0.0\:\d+\-\>4444\/tcp})
        end
      end

      it 'starts a container with the hostname set' do
        pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_3':
            image    => '#{default_image}',
            command  => '#{default_run_command}',
            hostname => 'testdomain.com',
            require  => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        container_id = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $1}'")

        run_shell("#{docker_command} exec #{container_id.stdout.strip} hostname") do |r|
          expect(r.stdout).to match(%r{testdomain.com})
        end
      end

      it 'starts a container while mounting local volumes' do
        pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_4':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            volumes => ["#{docker_mount_path}:#{docker_mount_path}/mnt:rw"],
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }

          file { '#{docker_mount_path}':
            ensure => directory,
            before => File['#{docker_mount_path}/test_mount.txt'],
          }

          file { '#{docker_mount_path}/test_mount.txt':
            ensure => present,
            before => Docker::Run['container_3_4'],
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4
        container_id = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $1}'")
        if os[:family] == 'windows'
          run_shell("#{docker_command} exec #{container_id.stdout.strip} cmd /c dir Users\\\\Public\\\\DockerVolume\\\\mnt") do |r|
            expect(r.stdout).to match(%r{test_mount.txt})
          end
        else
          run_shell("#{docker_command} exec #{container_id.stdout.strip} ls /root/mnt") do |r|
            expect(r.stdout).to match(%r{test_mount.txt})
          end
        end
      end

      # cpuset is not supported on Docker Windows
      # STDERR: C:/Program Files/Docker/docker.exe: Error response from daemon: invalid option: Windows does not support CpusetCpus.
      it 'starts a container with cpuset paramater set', win_broken: true do
        pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_5_5':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            cpuset  => ['0'],
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        run_shell('#{docker_command} inspect container_3_5_5') do |r|
          expect(r.stdout).to match(%r{"CpusetCpus"\: "0"})
        end
      end

      # leagacy container linking was not implemented on Windows. --link is a legacy Docker feature: https://docs.docker.com/network/links/
      it 'starts multiple linked containers', win_broken: true do
        pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_5_1':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        container1 = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $NF}'")

        pp2 = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_5_2':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            depends => ['#{container1.stdout.strip}'],
            links   => "#{container1.stdout.strip}:the_link",
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

        apply_manifest(pp2, catch_failures: true)
        apply_manifest(pp2, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        container2 = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $NF}'")

        container_id = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $1}'")
        run_shell("#{docker_command} inspect -f \"{{ .HostConfig.Links }}\" #{container_id.stdout.strip}") do |r|
          expect(r.stdout).to match("/#{container1.stdout.strip}:/#{container2.stdout.strip}/the_link")
        end
      end

      it 'stops a running container', win_broken: true do
        pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_6':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

        pp2 = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_6':
            image   => '#{default_image}',
            running => false,
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        run_shell("#{docker_command} ps | wc -l") do |r|
          expect(r.stdout).to match(%r{^2$})
        end

        apply_manifest(pp2, catch_failures: true)
        apply_manifest(pp2, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 4

        run_shell("#{docker_command} ps | wc -l") do |r|
          expect(r.stdout).to match(%r{^1$})
        end
      end

      it 'stops a running container and remove container' do
        pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_6_1':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

        pp2 = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_3_6_1':
            ensure  => 'absent',
            image   => '#{default_image}',
            require => Docker::Image['#{default_image}'],
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 15

        run_shell("#{docker_command} inspect container_3_6_1", expect_failures: false)

        apply_manifest(pp2, catch_failures: true)
        apply_manifest(pp2, catch_changes: true) unless selinux == 'true'

        # A sleep to give docker time to execute properly
        sleep 15

        run_shell("#{docker_command} inspect container_3_6_1", expect_failures: true)
      end

      it 'allows dependency for ordering of independent run and image' do
        pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}': }

          docker::run { 'container_3_7_1':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            #{default_docker_run_arg}
          }

          docker::image { '#{second_image}':
            require => Docker::Run['container_3_7_1'],
          }

          docker::run { 'container_3_7_2':
            image   => '#{second_image}',
            command => '#{default_run_command}',
            #{default_docker_run_arg}
          }
        EOS

        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true) unless selinux == 'true'
      end

      it 'restarts a unhealthy container' do
        pp5 = <<-EOS
        class { 'docker': #{docker_args} }
        docker::run { 'container_3_7_3':
          image   => '#{default_image}',
          command => '#{default_run_command}',
          health_check_cmd => 'echo',
          restart_on_unhealthy => true,
          #{default_docker_run_arg}
          }
          EOS

        pp_delete = <<-EOS
      class { 'docker': #{docker_args} }
      docker::run { 'container_3_7_3':
        image   => '#{default_image}',
        ensure  => absent,
        }
        EOS

        if os[:family] == 'windows'
          apply_manifest(pp5, catch_failures: true)
        elsif %r{^8$}.match?(os[:release])
          apply_manifest(pp5, catch_failures: true) do |r|
            expect(r.stdout).to match(%r{container_3_7_3})
          end
        else
          apply_manifest(pp5, catch_failures: true) do |r|
            expect(r.stdout).to match(%r{docker-container_3_7_3-systemd-reload})
          end
        end
        apply_manifest(pp_delete, catch_failures: true)
      end
    end

    it 'run with verify_digest' do
      pp = <<-EOS
        class { 'docker': #{docker_args} }
        docker::image { '#{default_image}:#{default_image_tag}':
            require => Class['docker'],
        }
        docker::run { '#{default_image}':
          image         => '#{default_image}:#{default_image_tag}',
          verify_digest => '#{default_local_digest}',
        }
        EOS
      pp_invalid = <<-EOS
        docker::run { '#{default_image}':
          image         => '#{default_image}:#{default_image_tag}',
          verify_digest => 'sha256:90659bf80b44ce6be8234e6ff90a1ac34acbeb826903b02cfa0da11c82cbc000',
        }
        EOS

      apply_manifest(pp, catch_failures: true)
      run_shell('/usr/local/bin/docker-run-alpine-start.sh', expect_failures: false) do |r|
        expect(r.stdout.include?('Digest verify failed!')).to be false
      end

      apply_manifest(pp_invalid, catch_failures: true)
      run_shell('/usr/local/bin/docker-run-alpine-start.sh', expect_failures: true) do |r|
        expect(r.stdout.include?('Digest verify failed!')).to be true
      end
    end
  end

  describe 'docker::exec', win_broken: true do
    it 'runs a command inside an already running container' do
      pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}':
            require => Class['docker'],
          }

          docker::run { 'container_4_1':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            require => Docker::Image['#{default_image}'],
            #{default_docker_run_arg}
          }
        EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true) unless selinux == 'true'

      # A sleep to give docker time to execute properly
      sleep 15

      container1 = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $NF}'")

      pp2 = <<-EOS
          class { 'docker': #{docker_args} }
          docker::exec { 'test_command':
            container => '#{container1.stdout.strip}',
            command   => '#{default_docker_exec_command}',
            tty       => true,
          }
        EOS

      pp_delete = <<-EOS
        docker::run { 'container_4_1':
          image   => '#{default_image}',
          ensure  => absent,
          }
          EOS

      apply_manifest(pp2, catch_failures: true)

      # A sleep to give docker time to execute properly
      sleep 4

      container_id = run_shell("#{docker_command} ps | awk 'FNR == 2 {print $1}'")
      if os[:family] == 'windows'
        run_shell("#{docker_command} exec #{container_id.stdout.strip} cmd /c dir Users\\\\Public") do |r|
          expect(r.stdout).to match(%r{test_file.txt})
        end
      else
        run_shell("#{docker_command} exec #{container_id.stdout.strip} ls /root") do |r|
          expect(r.stdout).to match(%r{test_file.txt})
        end
      end
      apply_manifest(pp_delete, catch_failures: true)
    end

    it 'onlies run if notified when refreshonly is true', win_broken: true do
      container_name = 'container_4_2'
      pp = <<-EOS
          class { 'docker': #{docker_args} }

          docker::image { '#{default_image}': }

          docker::run { '#{container_name}':
            image   => '#{default_image}',
            command => '#{default_run_command}',
            #{default_docker_run_arg}
          }

          docker::exec { 'test_command':
            container   => '#{container_name}',
            command     => '#{default_docker_exec_command}',
            refreshonly => true,
          }
        EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true) unless selinux == 'true'

      # A sleep to give docker time to execute properly
      sleep 4

      if os[:family] == 'windows'
        run_shell("#{docker_command} exec #{container_name} cmd /c dir Users\\\\Public") do |r|
          expect(r.stdout).not_to match(%r{test_file.txt})
        end
      else
        run_shell("#{docker_command} exec #{container_name} ls /root") do |r|
          expect(r.stdout).not_to match(%r{test_file.txt})
        end
      end

      pp_extra = <<-EOS
          file { '#{default_dockerfile}_dummy_file':
            ensure => 'present',
            notify => Docker::Exec['test_command'],
          }
        EOS

      pp_delete = <<-EOS
        docker::run { '#{container_name}':
          image   => '#{default_image}',
          ensure  => absent,
          }
          EOS

      pp2 = pp + pp_extra

      apply_manifest(pp2, catch_failures: true)
      apply_manifest(pp2, catch_changes: true) unless selinux == 'true'

      # A sleep to give docker time to execute properly
      sleep 4

      if os[:family] == 'windows'
        run_shell("#{docker_command} exec #{container_name} cmd /c dir Users\\\\Public") do |r|
          expect(r.stdout).to match(%r{home})
        end
      else
        run_shell("#{docker_command} exec #{container_name} ls /") do |r|
          expect(r.stdout).to match(%r{home})
        end
      end
      apply_manifest(pp_delete, catch_failures: true)
    end
  end
end
