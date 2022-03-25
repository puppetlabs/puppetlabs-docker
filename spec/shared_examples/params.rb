# frozen_string_literal: true

shared_examples 'params' do |_facts|
  case _facts[:os]['family']
  when 'Debian'
    it {
      is_expected.to contain_class('docker::params')
      is_expected.to contain_class('docker::systemd_reload')
      is_expected.to contain_exec('docker-systemd-reload').with(
        'path' => [
          '/bin/',
          '/sbin/',
          '/usr/bin/',
          '/usr/sbin/',
        ],
        'command'     => 'systemctl daemon-reload',
        'refreshonly' => 'true',
      )
    }
  end
end
