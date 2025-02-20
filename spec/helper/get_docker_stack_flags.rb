# frozen_string_literal: true

def get_docker_stack_flags(args)
  flags = []

  flags << "--bundle-file '#{args['bundle_file']}'" if args['bundle_file'] && args['bundle_file'].to_s != 'undef'

  if args['compose_files'] && args['compose_files'].to_s != 'undef'
    args['compose_files'].each do |file|
      flags << "--compose-file '#{file}'"
    end
  end

  flags << "--resolve-image '#{args['resolve_image']}'" if args['resolve_image'] && args['resolve_image'].to_s != 'undef'

  flags << '--prune' if args['prune'] && args['prune'].to_s != 'undef'

  flags << '--with-registry-auth' if args['with_registry_auth'] && args['with_registry_auth'].to_s != 'undef'

  flags.flatten.join(' ')
end
