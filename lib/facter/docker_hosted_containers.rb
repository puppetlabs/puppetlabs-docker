
require 'json'; 

Facter.add(:docker_hosted_containers) do
  setcode do
    containers_hash = {}
    containers_hash['container_ids'] = []
    docker_binary = Facter::Core::Execution.exec('/usr/bin/which docker') 
    if docker_binary !~ /docker/
      containers_hash['docker_host'] = 'not a docker host'
    else
      docker_hostname = Facter::Core::Execution.exec("hostname -f")
      containers_hash['docker_host'] = docker_hostname 
      container_array = Facter::Core::Execution.exec('/usr/bin/docker ps -q').chomp().split(/\n/)
      container_count = 0
      if container_array
        container_array.each do |container_id|
          container_count += 1
          container_inspect_json = Facter::Core::Execution.exec("/usr/bin/docker inspect #{container_id}")
          container_meta_data = JSON.parse( container_inspect_json )
          hostname = Facter::Core::Execution.exec("/usr/bin/docker inspect -f \"{{ .Name }}\" #{container_id}").sub(/^\//,"")
          ip = Facter::Core::Execution.exec("/usr/bin/docker inspect -f \"{{ .NetworkSettings.IPAddress }}\" #{container_id}")
          if hostname
            containers_hash[hostname] = container_meta_data[0]
          elsif ip
            containers_hash[ip] = container_meta_data
          end
          containers_hash['container_ids'].push(container_id)
        end
      end
      containers_hash['container_count'] = container_count
    end
    containers_hash
  end
end

