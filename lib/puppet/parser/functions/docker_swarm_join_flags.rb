# frozen_string_literal: true

require 'shellwords'
#
# docker_swarm_join_flags.rb
#
module Puppet::Parser::Functions
  # Transforms a hash into a string of docker swarm init flags
  newfunction(:docker_swarm_join_flags, type: :rvalue) do |args|
    opts = args[0] || {}
    flags = []

    flags << 'join' if opts['join'].to_s != 'false'

    flags << "--advertise-addr '#{opts['advertise_addr']}'" if opts['advertise_addr'] && opts['advertise_addr'].to_s != 'undef'

    flags << "--listen-addr \"#{opts['listen_addr']}\"" if opts['listen_addr'] && opts['listen_addr'].to_s != 'undef'

    flags << "--token '#{opts['token']}'" if opts['token'] && opts['token'].to_s != 'undef'

    flags.flatten.join(' ')
  end
end
