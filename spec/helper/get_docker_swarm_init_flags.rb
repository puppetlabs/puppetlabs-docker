# frozen_string_literal: true

def get_docker_swarm_init_flags(args)
  flags = []

  if args['init'].to_s != 'false'
    flags << 'init'
  end

  if args['advertise_addr'] && args['advertise_addr'].to_s != 'undef'
    flags << "--advertise-addr '#{args['advertise_addr']}'"
  end

  if args['autolock'].to_s != 'false'
    flags << '--autolock'
  end

  if args['cert_expiry'] && args['cert_expiry'].to_s != 'undef'
    flags << "--cert-expiry '#{args['cert_expiry']}'"
  end

  if args['default_addr_pool'].is_a? Array
    args['default_addr_pool'].each do |default_addr_pool|
      flags << "--default-addr-pool #{default_addr_pool}"
    end
  end

  if args['default_addr_pool_mask_length'] && args['default_addr_pool_mask_length'].to_s != 'undef'
    flags << "--default-addr-pool-mask-length '#{args['default_addr_pool_mask_length']}'"
  end

  if args['dispatcher_heartbeat'] && args['dispatcher_heartbeat'].to_s != 'undef'
    flags << "--dispatcher-heartbeat '#{args['dispatcher_heartbeat']}'"
  end

  if args['external_ca'] && args['external_ca'].to_s != 'undef'
    flags << "--external-ca '#{args['external_ca']}'"
  end

  if args['force_new_cluster'].to_s != 'false'
    flags << '--force-new-cluster'
  end

  if args['listen_addr'] && args['listen_addr'].to_s != 'undef'
    flags << "--listen-addr '#{args['listen_addr']}'"
  end

  if args['max_snapshots'] && args['max_snapshots'].to_s != 'undef'
    flags << "--max-snapshots '#{args['max_snapshots']}'"
  end

  if args['snapshot_interval'] && args['snapshot_interval'].to_s != 'undef'
    flags << "--snapshot-interval '#{args['snapshot_interval']}'"
  end

  flags.flatten.join(' ')
end
