require 'json'

Facter.add(:docker_hosted_containers) do
  setcode do
    docker_inspect="/usr/bin/docker inspect"
    service_inspect="/usr/bin/docker service inspect"
    containers_hash = {}
    containers_hash['container_ids'] = []
    containers_hash['service_ids'] = []
    docker_binary = Facter::Core::Execution.exec('/usr/bin/which docker')
    if docker_binary !~ %r{docker}
      containers_hash['docker_host'] = 'not a docker host'
    else
      docker_hostname = Facter::Core::Execution.exec('hostname -f')
      containers_hash['docker_host'] = docker_hostname
      container_array = Facter::Core::Execution.exec('/usr/bin/docker ps -q').chomp.split(%r{\n})
      container_count = 0
      service_count = 0
      service_container_count = 0
      if container_array
        container_array.each do |container_id|
          container_count += 1
          container_inspect_json = Facter::Core::Execution.exec("#{docker_inspect} #{container_id}")
          container_meta_data = JSON.parse(container_inspect_json)
          hostname = Facter::Core::Execution.exec("#{docker_inspect} -f \"{{ .Name }}\" #{container_id}").sub(%r{^/}, '')
          ip = Facter::Core::Execution.exec("#{docker_inspect} -f \"{{ .NetworkSettings.IPAddress }}\" #{container_id}")
          service_container_ip = Facter::Core::Execution.exec("#{docker_inspect} -f \"{{ .NetworkSettingsNetworks.ingress.IPAddress }}\" #{container_id}")
          if hostname
            containers_hash[hostname] = container_meta_data[0]
          elsif ip
            containers_hash[ip] = container_meta_data[0]
          elsif service_container_ip
            containers_hash[service_container_ip] = container_meta_data[0]
            service_container_count += 1
          end
          containers_hash['container_ids'].push(container_id)
        end
      end
      service_array = Facter::Core::Execution.exec('/usr/bin/docker service ls -q').chomp.split(%r{\n})
      if service_array
        service_array.each do |service_id|
          service_count += 1
          service_inspect_json = Facter::Core::Execution.exec("#{service_inspect} #{service_id}")
          service_meta_data = JSON.parse(service_inspect_json)
          service_hostname = Facter::Core::Execution.exec("#{service_inspect} -f \"{{ .Spec.TaskTemplate.ContainerSpec.Hostname }}\" #{service_id}").sub(%r{^/}, '')
          service_vip = Facter::Core::Execution.exec("#{service_inspect} -f \"{{ .Endpoint.VirtualIPs }}\" #{service_id} | awk \"{ print $2 }\" | sed \"s,/.*$,,\"")
          if service_hostname
            containers_hash[service_hostname] = service_meta_data[0]
          elsif service_vip
            containers_hash[service_vip] = service_meta_data[0]
          else
            containers_hash['service_errors'] += "Found no hostname or vip for #{service_id}"
          end
          containers_hash['service_ids'].push(service_id)
        end  
      end
      containers_hash['container_count'] = container_count
      containers_hash['service_count'] = service_count
      containers_hash['service_container_count'] = service_container_count
    end
    containers_hash
  end
end
