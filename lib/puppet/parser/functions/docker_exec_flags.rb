# frozen_string_literal: true

require 'shellwords'
#
# docker_exec_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of docker exec flags
  newfunction(:docker_exec_flags, type: :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    flags << '--detach=true' if opts['detach']

    flags << '--interactive=true' if opts['interactive']

    flags << '--tty=true' if opts['tty']

    opts['env']&.each do |namevaluepair|
      flags << "--env #{namevaluepair}"
    end

    flags.flatten.join(' ')
  end
end
