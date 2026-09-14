# frozen_string_literal: true

require 'deep_merge'

Puppet::Type.type(:docker_stack).provide(:ruby) do
  desc 'Support for Puppet running Docker Stacks'

  mk_resource_methods

  has_command(:docker, 'docker')

  def exists?
    Puppet.info("Checking for stack #{name}")
    stack_services = compose_stack_services
    swarm_services = swarm_service_images
    return false if stack_services.empty? || swarm_services.size != stack_services.size

    counts = Hash[*stack_services.each.map { |key, spec|
                    image = canonical_image(spec['image'] || get_image(key, stack_services))
                    Puppet.info("Checking for compose service #{key} #{image}")
                    ["#{key}-#{image}", swarm_services.count("#{key}-#{image}")]
                  }.flatten]
    if counts.empty? ||
       counts.any? { |_k, v| v.zero? }
      false
    else
      true
    end
  end

  def get_image(service_name, stack_services)
    image = stack_services[service_name]['image']
    unless image
      if stack_services[service_name]['extends']
        image = get_image(stack_services[service_name]['extends'], stack_services)
      elsif stack_services[service_name]['build']
        image = "#{name}_#{service_name}"
      end
    end
    image
  end

  def create
    Puppet.info("Running stack #{name}")
    args = ['stack', 'deploy', compose_files, name].insert(1, bundle_file).insert(4, resource[:up_args]).compact
    docker(args)
  end

  def destroy
    Puppet.info("Removing docker stack #{name}")
    rm_args = ['stack', 'rm', name]
    docker(rm_args)
  end

  def bundle_file
    resource[:bundle_file]&.map { |x| ['-c', x] }&.flatten
  end

  def compose_files
    resource[:compose_files].map { |x| ['-c', x] }.flatten
  end

  def compose_stack_services
    stack_services = {}
    resource[:compose_files].each do |file|
      compose_file = Puppet::Util::Yaml.safe_load(File.read(file))
      case compose_file['version']
      when %r{^3(\.[0-8])?$}
        stack_services.merge!(compose_file['services'])
      else
        raise(Puppet::Error, "Unsupported docker compose file syntax version \"#{compose_file['version']}\"!")
      end
    end
    stack_services
  end

  def swarm_service_images
    docker(['stack', 'services', '--format', '{{.Name}} {{.Image}}', name])
      .split("\n")
      .reject(&:empty?)
      .map do |line|
        svc, image = line.split(' ', 2)
        "#{svc.delete_prefix("#{name}_")}-#{canonical_image(image)}"
      end
  rescue Puppet::ExecutionFailure
    []
  end

  # Swarm pins resolved images as repo:tag@sha256:…. Compare repo:tag only.
  # :latest is added only when the last path segment has no colon, so
  # registry:5000/foo is untagged and registry:5000/foo:1.0 is not.
  def canonical_image(image)
    return if image.nil? || image.empty?

    image = image.sub(%r{@sha256:[0-9a-f]+\z}i, '')
    return "#{image}:latest" unless image.rpartition('/').last.include?(':')

    image
  end
end
