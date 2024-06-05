# frozen_string_literal: true

shared_examples 'compose' do |_params, _facts|
  ensure_value = _params['ensure']
  version      = _params['version']

  if _params['manage_package']
    ensure_value = if _params['version'] != :undef && _params['ensure'] != 'absent'
                   _params['version']
                 else
                   _params['ensure']
                 end

    case _facts['os']['family']
    when 'Debian', 'RedHat'
      it {
          is_expected.to contain_package('docker-compose-plugin').with(
            ensure: ensure_value,
          )
        } 
  end
end
