require 'json'

Puppet::Type.type(:docker_config).provide(:ruby) do
  desc 'Support for Docker configs'

  mk_resource_methods
  commands docker: 'docker'

  def config_conf
    flags = %w[config create]
    flags << resource[:name]
    flags << resource[:file]
  end

  def self.instances
    output = docker(%w[config ls --format {{.Name}}])
    lines = output.split("\n")
    lines.map do |name|
      inspect = docker(['config', 'inspect', name])
      obj = JSON.parse(inspect).first
      new(
        :id => obj['Id'],
        :name => obj['Spec']['Name'],
        :ensure  => :present,
      )
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if (resource = resources[prov.name])
        resource.provider = prov
      end
    end
  end

  def exists?
    Puppet.info("Checking if docker network #{name} exists")
    @property_hash[:ensure] == :present
  end

  def create
    Puppet.info("Creating docker config #{name}")
    docker(config_conf)
  end

  def destroy
    Puppet.info("Removing docker config #{name}")
    docker(['config', 'rm', name])
  end
end
