require 'facter'
require 'json'

def interfaces
  Facter.value(:interfaces).split(',')
end

Facter.add(:docker_client_version) do
  setcode do
    docker_version = Facter.value(:docker_version)
    docker_version['Client']['Version'] if docker_version
  end
end

Facter.add(:docker_server_version) do
  setcode do
    docker_version = Facter.value(:docker_version)
    docker_version['Server']['Version'] if docker_version
  end
end

Facter.add(:docker_version) do
  setcode do
    if Facter::Util::Resolution.which('docker')
      value = Facter::Core::Execution.execute(
        "docker version --format '{{json .}}'",
      )
      val = JSON.parse(value)
    end
    val
  end
end

Facter.add(:docker) do
  setcode do
    if Facter::Util::Resolution.which('docker')
      docker_json_str = Facter::Util::Resolution.exec(
        "docker info --format '{{json .}}'",
      )
      docker = JSON.parse(docker_json_str)
      docker['network'] = {}

      docker['network']['managed_interfaces'] = {}
      network_list = Facter::Util::Resolution.exec('docker network ls | tail -n +2')
      docker_network_names = []
      network_list.each_line { |line| docker_network_names.push line.split[1] }
      docker_network_ids = []
      network_list.each_line { |line| docker_network_ids.push line.split[0] }
      docker_network_names.each do |network|
        inspect = JSON.parse(Facter::Util::Resolution.exec("docker network inspect #{network}"))
        docker['network'][network] = inspect[0]
        network_id = docker['network'][network]['Id'][0..11]
        interfaces.each do |iface|
          docker['network']['managed_interfaces'][iface] = network if iface =~ %r{#{network_id}}
        end
      end
      docker
    end
  end
end
