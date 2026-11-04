# frozen_string_literal: true

# Arch Linux is a rolling release, so metadata.json lists its release as 'rolling'
# (puppet_litmus requires every supported OS to have a release). FacterDB's Arch
# Linux facts report the kernel version as os.release, though, so rspec-puppet-facts
# would never match 'rolling' and would silently skip Arch Linux. Match rolling
# releases on the operating system name only.
module RollingReleaseSupportedOs
  def meta_supported_os
    super.map do |os|
      (os['operatingsystemrelease'] == ['rolling']) ? os.except('operatingsystemrelease') : os
    end
  end
end
RspecPuppetFacts.singleton_class.prepend(RollingReleaseSupportedOs)
