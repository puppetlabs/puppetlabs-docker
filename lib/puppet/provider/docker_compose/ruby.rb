# frozen_string_literal: true

require 'deep_merge'

Puppet::Type.type(:docker_compose).provide(:ruby) do
  desc 'Support for Puppet running Docker Compose'

  mk_resource_methods
  commands dockercompose: 'docker-compose'
  commands dockercmd: 'docker'

  has_command(:docker, command(:dockercmd)) do
    environment(HOME: '/var/tmp')
  end

  def exists?
    Puppet.info("Checking for compose project #{name}")
    compose_services = {}
    compose_containers = []

    # get merged config using docker-compose config
    args = [compose_files, '-p', name, 'config'].insert(3, resource[:options]).compact
    compose_output = YAML.safe_load(execute([command(:dockercompose)] + args, combine: false))

    # rubocop:disable Style/StringLiterals
    containers = docker([
                          'ps',
                          '--format',
                          "{{.Label \"com.docker.compose.service\"}}-{{.Image}}",
                          '--filter',
                          "label=com.docker.compose.project=#{name}",
                        ]).split("\n")
    compose_containers.push(*containers)
    compose_containers.uniq!

    compose_services = compose_output['services']

    if compose_services.count != compose_containers.count
      return false
    end

    counts = Hash[*compose_services.each.map { |key, array|
                    image = (array['image']) ? array['image'] : get_image(key, compose_services)
                    Puppet.info("Checking for compose service #{key} #{image}")
                    ["#{key}-#{image}", compose_containers.count("#{key}-#{image}")]
                  }.flatten]

    # No containers found for the project
    if counts.empty? ||
       # Containers described in the compose file are not running
       counts.any? { |_k, v| v.zero? } ||
       # The scaling factors in the resource do not match the number of running containers
       resource[:scale] && counts.merge(resource[:scale]) != counts
      false
    else
      true
    end
  end

  def get_image(service_name, compose_services)
    image = compose_services[service_name]['image']
    unless image
      if compose_services[service_name]['extends']
        image = get_image(compose_services[service_name]['extends'], compose_services)
      elsif compose_services[service_name]['build']
        image = "#{name}_#{service_name}"
      end
    end
    image
  end

  def create
    Puppet.info("Running compose project #{name}")
    args = [compose_files, '-p', name, 'up', '-d', '--remove-orphans'].insert(3, resource[:options]).insert(5, resource[:up_args]).compact
    dockercompose(args)
    return unless resource[:scale]
    instructions = resource[:scale].map { |k, v| "#{k}=#{v}" }
    Puppet.info("Scaling compose project #{name}: #{instructions.join(' ')}")
    args = [compose_files, '-p', name, 'scale'].insert(3, resource[:options]).compact + instructions
    dockercompose(args)
  end

  def destroy
    Puppet.info("Removing all containers for compose project #{name}")
    kill_args = [compose_files, '-p', name, 'kill'].insert(3, resource[:options]).compact
    dockercompose(kill_args)
    rm_args = [compose_files, '-p', name, 'rm', '--force', '-v'].insert(3, resource[:options]).compact
    dockercompose(rm_args)
  end

  def restart
    return unless exists?
    Puppet.info("Rebuilding and Restarting all containers for compose project #{name}")
    kill_args = [compose_files, '-p', name, 'kill'].insert(3, resource[:options]).compact
    dockercompose(kill_args)
    build_args = [compose_files, '-p', name, 'build'].insert(3, resource[:options]).compact
    dockercompose(build_args)
    create
  end

  def compose_files
    resource[:compose_files].map { |x| ['-f', x] }.flatten
  end

  private
end
