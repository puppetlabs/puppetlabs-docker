# frozen_string_literal: true

def get_docker_stack_flags(args)
  flags = []

  if args['bundle_file'] && args['bundle_file'].to_s != 'undef'
    flags << "--bundle-file '#{args['bundle_file']}'"
  end

  if args['compose_files'] && args['compose_files'].to_s != 'undef'
    args['compose_files'].each do |file|
      flags << "--compose-file '#{file}'"
    end
  end

  if args['resolve_image'] && args['resolve_image'].to_s != 'undef'
    flags << "--resolve-image '#{args['resolve_image']}'"
  end

  if args['prune'] && args['prune'].to_s != 'undef'
    flags << '--prune'
  end

  if args['with_registry_auth'] && args['with_registry_auth'].to_s != 'undef'
    flags << '--with-registry-auth'
  end

  flags.flatten.join(' ')
end
