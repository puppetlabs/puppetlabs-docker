# frozen_string_literal: true

def get_docker_swarm_join_flags(args)
  flags = []

  if args['join'].to_s != 'false'
    flags << 'join'
  end

  if args['advertise_addr'] && args['advertise_addr'].to_s != 'undef'
    flags << "--advertise-addr '#{args['advertise_addr']}'"
  end

  if args['listen_addr'] && args['listen_addr'].to_s != 'undef'
    flags << "--listen-addr \"#{args['listen_addr']}\""
  end

  if args['token'] && args['token'].to_s != 'undef'
    flags << "--token '#{args['token']}'"
  end

  flags.flatten.join(' ')
end
