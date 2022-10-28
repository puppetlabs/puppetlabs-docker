# frozen_string_literal: true

require 'spec_helper_acceptance'

if os[:family] == 'windows'
  os_name = run_shell('systeminfo | findstr /R /C:"OS Name"')
  raise 'Could not retrieve systeminfo for Windows box' if os_name.exit_code != 0
  os_name = if os_name.stdout.split(%r{\s}).include?('2016')
              'win-2016'
            elsif os_name.stdout.split(%r{\s}).include?('2019')
              'win-2019'
            else
              'win-2022'
            end
  docker_args = 'docker_ee => true'
  docker_network = 'nat'
  volume_location = 'C:\\'
  docker_image = if os_name == 'win-2016'
                   'stefanscherer/nanoserver:sac2016'
                 else
                   'stefanscherer/nanoserver:10.0.17763.1040'
                 end
else
  docker_args = ''
  docker_network = 'bridge'
  volume_location = '/opt/'
  docker_image = 'hello-world:linux'
end

describe 'docker trigger parameters change', if: fetch_puppet_version > 5 do
  before(:all) do
    if os[:family] != 'windows'
      install_pp = "class { 'docker': #{docker_args}}"
      apply_manifest(install_pp)
    end
    run_shell("mkdir #{volume_location}volume_1")
    run_shell("mkdir #{volume_location}volume_2")
  end

  context 'when image is changed' do
    image_changed = if os[:family] == 'windows'
                      if os_name == 'win-2016'
                        'stefanscherer/nanoserver:10.0.14393.2551'
                      else
                        'stefanscherer/nanoserver:1809'
                      end
                    else
                      'hello-world:latest'
                    end
    let(:pp1) do
      "
          class {'docker': #{docker_args}}
          docker::run {'servercore': image => '#{docker_image}', restart => 'always', net => '#{docker_network}' }
      "
    end

    let(:pp2) do
      "
          class {'docker': #{docker_args}}
          docker::run {'servercore': image => '#{image_changed}', restart => 'always', net => '#{docker_network}' }
      "
    end

    it 'creates servercore with first image' do
      expect(docker_run_idempotent_apply(pp1)).to be true
    end

    it 'detect image change and apply the change' do
      apply_manifest(pp2, catch_failures: true)
      run_shell('docker inspect --format="{{ .Config.Image }}" servercore') do |r|
        expect(r.stdout).to match(%r{#{image_changed}})
      end
    end
  end

  context 'when volumes parameter is changed' do
    if os[:family] == 'windows'
      volumes1 = "volumes => ['volume-1:C:\\volume_1']"
      volumes2 = "volumes => ['volume-1:C:\\volume_1', 'volume-2:C:\\volume_2']"
    else
      volumes1 = "volumes => ['volume-1:#{volume_location}volume_1']"
      volumes2 = "volumes => ['volume-1:#{volume_location}volume_1', 'volume-2:#{volume_location}volume_2']"
    end

    let(:pp1) do
      "
          class {'docker': #{docker_args}}
          docker::run {'servercore': image => '#{docker_image}', restart => 'always', net => '#{docker_network}', #{volumes1}}
      "
    end

    let(:pp2) do
      "
          class {'docker': #{docker_args}}
          docker::run {'servercore': image => '#{docker_image}', restart => 'always', net => '#{docker_network}', #{volumes2}}
      "
    end

    it "creates servercore with #{volumes1}" do
      expect(docker_run_idempotent_apply(pp1)).to be true
    end

    it "creates servercore with #{volumes2}" do
      apply_manifest(pp2, catch_failures: true)
      run_shell('docker inspect servercore --format="{{ json .Mounts }}"') do |r|
        inspect_result = JSON.parse(r.stdout)
        inspect_result = inspect_result.map { |item| item['Name'] }.sort
        expect(inspect_result).to eq(['volume-1', 'volume-2'])
      end
    end
  end

  context 'when ports parameter is changed' do
    ports1 = "ports => ['4444']"
    ports2 = "ports => ['4444', '4445']"

    let(:pp1) do
      "
          class {'docker': #{docker_args}}
          docker::run {'servercore': image => '#{docker_image}', restart => 'always', net => '#{docker_network}', #{ports1}}
      "
    end

    let(:pp2) do
      "
          class {'docker': #{docker_args}}
          docker::run {'servercore': image => '#{docker_image}', restart => 'always', net => '#{docker_network}', #{ports2}}
      "
    end

    it 'creates servercore with ports => ["4444"]' do
      expect(docker_run_idempotent_apply(pp1)).to be true
    end

    it 'creates servercore with ports => ["4444", "4445"]' do
      apply_manifest(pp2, catch_failures: true)
      run_shell('docker inspect servercore --format="{{ json .HostConfig.PortBindings }}"') do |r|
        inspect_result = JSON.parse(r.stdout)
        inspect_result = inspect_result.keys.map { |item| item.split('/')[0] }.sort
        expect(inspect_result).to eq(['4444', '4445'])
      end
    end
  end

  after(:all) do
    run_shell("rm -r #{volume_location}volume_1")
    run_shell("rm -r #{volume_location}volume_2")
  end
end
