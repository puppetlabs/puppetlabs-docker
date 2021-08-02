# frozen_string_literal: true

Puppet::Functions.create_function(:docker_params_changed) do
  dispatch :detect_changes do
    param 'Hash', :opts
    return_type 'String'
  end

  def run_with_powershell(cmd)
    "powershell.exe -Command \"& {#{cmd}}\" "
  end

  def remove_cidfile(cidfile, osfamily)
    delete_command = if osfamily == 'windows'
                       run_with_powershell("del #{cidfile}")
                     else
                       "rm -f #{cidfile}"
                     end
    _stdout, _stderr, _status = Open3.capture3(delete_command)
  end

  def start_container(name, osfamily)
    start_command = if osfamily == 'windows'
                      run_with_powershell("docker start #{name}")
                    else
                      "docker start #{name}"
                    end
    _stdout, _stderr, _status = Open3.capture3(start_command)
  end

  def stop_container(name, osfamily)
    stop_command = if osfamily == 'windows'
                     run_with_powershell("docker stop #{name}")
                   else
                     "docker stop #{name}"
                   end
    _stdout, _stderr, _status = Open3.capture3(stop_command)
  end

  def remove_container(name, osfamily, stop_wait_time, cidfile)
    stop_command = if osfamily == 'windows'
                     run_with_powershell("docker stop --time=#{stop_wait_time} #{name}")
                   else
                     "docker stop --time=#{stop_wait_time} #{name}"
                   end
    _stdout, _stderr, _status = Open3.capture3(stop_command)

    remove_command = if osfamily == 'windows'
                       run_with_powershell("docker rm -v #{name}")
                     else
                       "docker rm -v #{name}"
                     end
    _stdout, _stderr, _status = Open3.capture3(remove_command)

    remove_cidfile(cidfile, osfamily)
  end

  def create_container(cmd, osfamily, image)
    pull_command = if osfamily == 'windows'
                     run_with_powershell("docker pull #{image} -q")
                   else
                     "docker pull #{image} -q"
                   end
    _stdout, _stderr, _status = Open3.capture3(pull_command)

    create_command = if osfamily == 'windows'
                       run_with_powershell(cmd)
                     else
                       cmd
                     end
    _stdout, _stderr, _status = Open3.capture3(create_command)
  end

  def detect_changes(opts)
    require 'open3'
    require 'json'
    return_value = 'No changes detected'

    if opts['sanitised_title'] && opts['osfamily']
      stdout, _stderr, status = Open3.capture3("docker inspect #{opts['sanitised_title']}")
      if status.to_s.include?('exit 0')
        param_changed = false
        inspect_hash = JSON.parse(stdout)[0]

        # check if the image was changed
        param_changed = true if opts['image'] && opts['image'] != inspect_hash['Config']['Image']

        # check if something on volumes or mounts was changed(a new volume/mount was added or removed)
        param_changed = true if opts['volumes'].is_a?(String) && opts['volumes'].include?(':') && opts['volumes'] != inspect_hash['Mounts'].to_a[0] && opts['osfamily'] != 'windows'
        param_changed = true if opts['volumes'].is_a?(String) && !opts['volumes'].include?(':') && opts['volumes'] != inspect_hash['Config']['Volumes'].to_a[0] && opts['osfamily'] != 'windows'
        param_changed = true if opts['volumes'].is_a?(String) && opts['volumes'].scan(%r{(?=:)}).count == 2 && opts['volumes'] != inspect_hash['Mounts'].to_a[0] && opts['osfamily'] == 'windows'
        param_changed = if opts['volumes'].is_a?(String) && opts['volumes'].scan(%r{(?=:)}).count == 1 && opts['volumes'] != inspect_hash['Config']['Volumes'].to_a[0] && opts['osfamily'] == 'windows'
                          true
                        else
                          param_changed
                        end

        pp_paths = opts['volumes'].reject { |item| item.include?(':') } if opts['volumes'].is_a?(Array) && opts['osfamily'] != 'windows'
        pp_mounts = opts['volumes'].select { |item| item.include?(':') } if opts['volumes'].is_a?(Array) && opts['osfamily'] != 'windows'
        pp_paths = opts['volumes'].select { |item| item.scan(%r{(?=:)}).count == 1 } if opts['volumes'].is_a?(Array) && opts['osfamily'] == 'windows'
        pp_mounts = opts['volumes'].select { |item| item.scan(%r{(?=:)}).count == 2 } if opts['volumes'].is_a?(Array) && opts['osfamily'] == 'windows'

        inspect_paths = if inspect_hash['Config']['Volumes']
                          inspect_hash['Config']['Volumes'].keys
                        else
                          []
                        end
        param_changed = true if pp_paths != inspect_paths

        names = inspect_hash['Mounts'].map { |item| item.values[1] } if inspect_hash['Mounts']
        pp_names = pp_mounts.map { |item| item.split(':')[0] } if pp_mounts
        names = names.select { |item| pp_names.include?(item) } if names && pp_names
        destinations = inspect_hash['Mounts'].map { |item| item.values[3] } if inspect_hash['Mounts']
        pp_destinations = pp_mounts.map { |item| item.split(':')[1] } if pp_mounts && opts['osfamily'] != 'windows'
        pp_destinations = pp_mounts.map { |item| "#{item.split(':')[1].downcase}:#{item.split(':')[2]}" } if pp_mounts && opts['osfamily'] == 'windows'
        destinations = destinations.select { |item| pp_destinations.include?(item) } if destinations && pp_destinations

        param_changed = true if pp_names != names
        param_changed = true if pp_destinations != destinations
        param_changed = true if pp_mounts != [] && inspect_hash['Mounts'].nil?

        # check if something on ports was changed(some ports were added or removed)

        ports = inspect_hash['HostConfig']['PortBindings'].keys
        ports = ports.map { |item| item.split('/')[0] }
        pp_ports = opts['ports'].sort if opts['ports'].is_a?(Array)
        pp_ports = [opts['ports']] if opts['ports'].is_a?(String)

        param_changed = true if pp_ports && pp_ports != ports

        if param_changed
          remove_container(opts['sanitised_title'], opts['osfamily'], opts['stop_wait_time'], opts['cidfile'])
          create_container(opts['command'], opts['osfamily'], opts['image'])
          return_value = 'Param changed'
        end
      else
        create_container(opts['command'], opts['osfamily'], opts['image']) unless File.exist?(opts['cidfile'])
        _stdout, _stderr, status = Open3.capture3("docker inspect #{opts['sanitised_title']}")
        unless status.to_s.include?('exit 0')
          remove_cidfile(opts['cidfile'], opts['osfamily'])
          create_container(opts['command'], opts['osfamily'], opts['image'])
        end
        return_value = 'No changes detected'
      end
    else
      return_value = 'Arg required missing'
    end

    if opts['container_running']
      start_container(opts['sanitised_title'], opts['osfamily'])
    else
      stop_container(opts['sanitised_title'], opts['osfamily'])
    end

    return_value
  end
end
