shared_examples 'params' do |_facts|
  case _facts[:os]['family']
  when 'Debian'
    if _facts[:os]['release']['full'] != '14.04'
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
end
