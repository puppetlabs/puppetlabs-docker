# frozen_string_literal: true

def get_values_init(_params, _facts)
  if _params['version'] == :undef || _params['version'] !~ %r{^(17[.][0-1][0-9][.][0-1](~|-|\.)ce|1.\d+)}
    if _params['docker_ee']
      package_location         = _params['docker_ee_source_location']
      package_key_source       = _params['docker_ee_key_source']
      package_key_check_source = true
      package_key              = _params['docker_ee_key_id']
      package_repos            = _params['docker_ee_repos']
      release                  = _params['docker_ee_release']
      docker_start_command     = _params['docker_ee_start_command']
      docker_package_name      = _params['docker_ee_package_name']
    else
      case _facts[:os]['family']
      when 'Debian'
        package_location   = _params['docker_ce_source_location']
        package_key_source = _params['docker_ce_key_source']
        package_key        = _params['docker_ce_key_id']
        package_repos      = _params['docker_ce_channel']
        release            = _params['docker_ce_release']
      when 'RedHat'
        package_location         = _params['docker_ce_source_location']
        package_key_source       = _params['docker_ce_key_source']
        package_key_check_source = true
      # when 'windows'
      #   fail('This module only work for Docker Enterprise Edition on Windows.')
      else
        package_location         = _params['docker_package_location']
        package_key_source       = _params['docker_package_key_source']
        package_key_check_source = _params['docker_package_key_check_source']
      end

      docker_start_command = _params['docker_ce_start_command']
      docker_package_name  = _params['docker_ce_package_name']
    end
  else
    case _facts[:os]['family']
    when 'Debian'
      package_location         = _params['docker_package_location']
      package_key_source       = _params['docker_package_key_source']
      package_key_check_source = _params['docker_package_key_check_source']
      package_key              = _params['docker_package_key_id']
      package_repos            = 'main'
      release                  = _params['docker_package_release']
    when 'RedHat'
      package_location         = _params['docker_package_location']
      package_key_source       = _params['docker_package_key_source']
      package_key_check_source = _params['docker_package_key_check_source']
    else
      package_location         = _params['docker_package_location']
      package_key_source       = _params['docker_package_key_source']
      package_key_check_source = _params['docker_package_key_check_source']
    end

    docker_start_command = _params['docker_engine_start_command']
    docker_package_name  = _params['docker_engine_package_name']
  end

  root_dir_flag = if _params['version'] != :undef && _params['version'] =~ %r{^(17[.]0[0-4]|1.\d+)}
                    '-g'
                  else
                    '--data-root'
                  end

  {
    'docker_package_name'      => docker_package_name,
    'docker_start_command'     => docker_start_command,
    'package_key'              => package_key,
    'package_key_check_source' => package_key_check_source,
    'package_key_source'       => package_key_source,
    'package_location'         => package_location,
    'package_repos'            => package_repos,
    'release'                  => release,
    'root_dir_flag'            => root_dir_flag,
  }
end
