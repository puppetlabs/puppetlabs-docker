# frozen_string_literal: true

shared_examples 'repos' do |params, facts|
  it {
    is_expected.to contain_class('docker::repos')
  }

  values = get_values_init(params, facts)

  location         = values['package_location']
  key_source       = values['package_key_source']
  key_check_source = values['package_key_check_source']
  architecture     = facts[:os]['architecture']
  keyring          = params['keyring']
  os_lc            = params['os_lc']

  unless params['prerequired_packages'].empty?
    params['prerequired_packages'].each do |package|
      it {
        is_expected.to contain_package(package)
      }
    end
  end

  case facts[:os]['family']
  when 'Debian'
    release       = values['release']
    package_key   = values['package_key']
    package_repos = values['package_repos']

    if params['use_upstream_package_source']
      # check if debian version is atleast 11 and ubuntu version is atleast 22
      if (facts[:operatingsystem] == 'Debian' && facts[:operatingsystemrelease] =~ /1[1-9]/) || (facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemrelease] =~ /2[2-9]/)
        it {
          is_expected.to contain_class('archive')
          is_expected.to contain_archive(keyring).with(
            'ensure'          => 'present',
            'source'          => "https://download.docker.com/linux/#{os_lc}/gpg",
            'extract'         => true,
            'extract_command' => 'gpg',
            'extract_flags'   => "--dearmor -o #{keyring}",
            'extract_path'    => '/tmp',
            'path'            => '/tmp/docker.gpg',
            'creates'         => keyring,
            'cleanup'         => true,
          ).that_requires('Package[gpg]')

          is_expected.to contain_file(keyring).with(
            'ensure'  => 'file',
            'mode'    => '0644',
            'owner'   => 'root',
            'group'   => 'root',
          )

          is_expected.to contain_apt__source('docker').with(
            'location'     => location,
            'architecture' => architecture,
            'release'      => release,
            'repos'        => package_repos,
            'keyring'      => keyring,
            'include' => {
              'src' => false,
            },
          )

          is_expected.to contain_apt__key('docker-key-in-trusted.gpg').with(
            'ensure' => 'absent',
            'id'     => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
          )
        }
      else
        it {
          is_expected.to contain_apt__source('docker').with(
            'location'     => location,
            'architecture' => architecture,
            'release'      => release,
            'repos'        => package_repos,
            'key'          => {
              'id'     => package_key,
              'source' => key_source,
            },
            'include' => {
              'src' => false,
            },
          )
        }
      end

      url_split  = location.split('/')
      repo_host  = url_split[2]
      pin_ensure =  case params['pin_upstream_package_source']
                    when true
                      'present'
                    else
                      'absent'
                    end

      it {
        is_expected.to contain_apt__pin('docker').with(
          'ensure'   => pin_ensure,
          'origin'   => repo_host,
          'priority' => params['apt_source_pin_level'],
        )
      }

      if params['manage_package']
        it {
          is_expected.to contain_class('apt')
        }

        if facts[:os]['name'] == 'Debian' && facts[:os]['distro']['codename'] == 'wheezy'
          it {
            is_expected.to contain_class('apt::backports')
          }
        end

        it {
          params['prerequired_packages'].each do |package|
            is_expected.to contain_exec('apt_update').that_comes_before("package[#{package}]")
          end

          is_expected.to contain_apt__source('docker').that_comes_before('package[docker]')
        }
      end
    end
  when 'RedHat'
    if params['manage_package']
      baseurl      = case location
                     when :undef
                       nil
                     else
                       location
                     end
      gpgkey       = case key_source
                     when :undef
                       nil
                     else
                       key_source
                     end
      gpgkey_check = key_check_source

      if params['use_upstream_package_source']
        it {
          is_expected.to contain_yumrepo('docker').with(
            'descr'    => 'Docker',
            'baseurl'  => baseurl,
            'gpgkey'   => gpgkey,
            'gpgcheck' => gpgkey_check,
          ).that_comes_before('package[docker]')
        }
      end
    end
  end
end
