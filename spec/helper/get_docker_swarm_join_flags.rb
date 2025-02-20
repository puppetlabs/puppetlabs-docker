# frozen_string_literal: true

def get_docker_swarm_join_flags(args)
  flags = []

  flags << 'join' if args['join'].to_s != 'false'

  flags << "--advertise-addr '#{args['advertise_addr']}'" if args['advertise_addr'] && args['advertise_addr'].to_s != 'undef'

  flags << "--listen-addr \"#{args['listen_addr']}\"" if args['listen_addr'] && args['listen_addr'].to_s != 'undef'

  flags << "--token '#{args['token']}'" if args['token'] && args['token'].to_s != 'undef'

  flags.flatten.join(' ')
end
