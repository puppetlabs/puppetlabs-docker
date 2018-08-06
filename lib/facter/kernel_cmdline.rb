#!/usr/bin/env ruby
require 'facter'

Facter.add(:kernel_cmdline) do
  setcode '/bin/cat /proc/cmdline'
end

