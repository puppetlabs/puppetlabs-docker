# frozen_string_literal: true

def get_docker_swarm_init_flags(args)
  flags = []

  flags << 'init' if args['init'].to_s != 'false'

  flags << "--advertise-addr '#{args['advertise_addr']}'" if args['advertise_addr'] && args['advertise_addr'].to_s != 'undef'

  flags << '--autolock' if args['autolock'].to_s != 'false'

  flags << "--cert-expiry '#{args['cert_expiry']}'" if args['cert_expiry'] && args['cert_expiry'].to_s != 'undef'

  if args['default_addr_pool'].is_a? Array
    args['default_addr_pool'].each do |default_addr_pool|
      flags << "--default-addr-pool #{default_addr_pool}"
    end
  end

  flags << "--default-addr-pool-mask-length '#{args['default_addr_pool_mask_length']}'" if args['default_addr_pool_mask_length'] && args['default_addr_pool_mask_length'].to_s != 'undef'

  flags << "--dispatcher-heartbeat '#{args['dispatcher_heartbeat']}'" if args['dispatcher_heartbeat'] && args['dispatcher_heartbeat'].to_s != 'undef'

  flags << "--external-ca '#{args['external_ca']}'" if args['external_ca'] && args['external_ca'].to_s != 'undef'

  flags << '--force-new-cluster' if args['force_new_cluster'].to_s != 'false'

  flags << "--listen-addr '#{args['listen_addr']}'" if args['listen_addr'] && args['listen_addr'].to_s != 'undef'

  flags << "--max-snapshots '#{args['max_snapshots']}'" if args['max_snapshots'] && args['max_snapshots'].to_s != 'undef'

  flags << "--snapshot-interval '#{args['snapshot_interval']}'" if args['snapshot_interval'] && args['snapshot_interval'].to_s != 'undef'

  flags.flatten.join(' ')
end
