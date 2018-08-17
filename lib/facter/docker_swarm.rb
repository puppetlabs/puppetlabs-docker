require 'json'

Facter.add(:docker_swarm) do
  setcode do
    services_hash = {}
    services_hash['service_ids'] = []
    docker_binary = Facter::Core::Execution.exec('/usr/bin/which docker')
    swarm_status = Facter::Core::Execution.exec("#{docker_binary} info -f '{{json .Swarm.ControlAvailable }}'")
    if docker_binary !~ %r{docker}
      services_hash['docker_host'] = 'not a docker host'
    elsif swarm_status == false
      services_hash['docker_host'] = 'docker host not running swarm'
    else
      docker_hostname = Facter::Core::Execution.exec('hostname -f')
      services_hash['docker_host'] = docker_hostname
      service_count = 0
      service_array = Facter::Core::Execution.exec("#{docker_binary} service ls | /usr/bin/awk '{ print $2 }'").split(%{\n})
      if service_array
        service_array.each do |service_id|
          service_count += 1
          service_inspect_json = Facter::Core::Execution.exec("#{docker_binary} inspect #{service_id}")
          service_meta_data = JSON.parse(service_inspect_json)
          hostname = Facter::Core::Execution.exec("#{docker_binary} inspect -f \"{{ .Name }}\" #{service_id}").sub(%r{^/}, '')
          ip = Facter::Core::Execution.exec("#{docker_binary} inspect -f \"{{ .NetworkSettings.IPAddress }}\" #{service_id}")
          if hostname
            services_hash[hostname] = service_meta_data[0]
          elsif ip
            services_hash[ip] = service_meta_data
          end
          services_hash['service_ids'].push(service_id)
        end
      end
      services_hash['service_count'] = service_count
    end
    services_hash
  end
end
