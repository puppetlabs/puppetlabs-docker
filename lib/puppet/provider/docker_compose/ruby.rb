Puppet::Type.type(:docker_compose).provide(:ruby) do
  desc 'Support for Puppet running Docker Compose'

  mk_resource_methods
  commands dockercompose: 'docker-compose'
  commands docker: 'docker'

  def exists?
    Puppet.info("Checking for compose project #{project}")
    compose_file = YAML.safe_load(File.read(name))
    containers = docker([
                          'ps',
                          '--format',
                          "{{.Label \"com.docker.compose.service\"}}-{{.Image}}",
                          '--filter',
                          "label=com.docker.compose.project=#{project}",
                        ]).split("\n")
    counts = case compose_file['version']
             when %r{^2(\.0)?$/, /^3(\.[0-2])?$}
               if containers.count != compose_file['services'].count
                 return false
               end
               Hash[*compose_file['services'].each.map { |key, array|
                 Puppet.info("Checking for compose service #{key} #{array['image']}")
                 ["#{key}-#{array['image']}", containers.count("#{key}-#{array['image']}")]
               }.flatten]
             when nil
               if containers.count != compose_file.count
                 return false
               end
               Hash[*compose_file.each.map { |key, array|
                 Puppet.info("Checking for compose service #{key} #{array['image']}")
                 ["#{key}-#{array['image']}", containers.count("#{key}-#{array['image']}")]
               }.flatten]
             else
               raise(Puppet::Error, "Unsupported docker compose file syntax version \"#{compose_file['version']}\"!")
             end
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

  def create
    Puppet.info("Running compose project #{project}")
    args = ['-f', name, 'up', '-d', '--remove-orphans'].insert(2, resource[:options]).insert(5, resource[:up_args]).compact
    dockercompose(args)
    return unless resource[:scale]
    instructions = resource[:scale].map { |k, v| "#{k}=#{v}" }
    Puppet.info("Scaling compose project #{project}: #{instructions.join(' ')}")
    args = ['-f', name, 'scale'].insert(2, resource[:options]).compact + instructions
    dockercompose(args)
  end

  def destroy
    Puppet.info("Removing all containers for compose project #{project}")
    kill_args = ['-f', name, 'kill'].insert(2, resource[:options]).compact
    dockercompose(kill_args)
    rm_args = ['-f', name, 'rm', '--force', '-v'].insert(2, resource[:options]).compact
    dockercompose(rm_args)
  end

  def restart
    return unless exists?
    Puppet.info("Rebuilding and Restarting all containers for compose project #{project}")
    kill_args = ['-f', name, 'kill'].insert(2, resource[:options]).compact
    dockercompose(kill_args)
    build_args = ['-f', name, 'build'].insert(2, resource[:options]).compact
    dockercompose(build_args)
    create
  end

  private

  def project
    File.basename(File.dirname(name)).downcase.gsub(%r{[^0-9a-z ]}i, '')
  end
end
