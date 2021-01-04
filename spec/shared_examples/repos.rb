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
