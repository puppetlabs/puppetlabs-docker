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
        # we need to split the mounts from the manifest based on types (binds and volumes)
        # we then do a similar split on inspect[hostconfig][mounts]
        # TODO make volumes an array vs mixed type support; this feels like it was partially attempted with any2array()
        # TODO handle checking options better
        pp_binds = []
        pp_volumes = []
        if opts['osfamily'] != 'windows'
            vols = opts['volumes'].is_a?(String) ? [opts['volumes']] : opts['volumes']
            vols.each do |vol|
                vol_params = vol.split(':')
                # we are going to assume that if length is 1 or the first char of the first element is not one of [./~] it is a volume
                if vol_params.length == 1
                    t_vol = { 'destination' => vol_params[0], 'rw' => true}
                    # not pushing this to the array because i'm not sure how to deal with the compare...
                    #pp_volumes.append(t_vol)
                elsif not ['.', '~', '/'].include?(vol_params[0][0])
                    # this next line is fragile and likely to break because it assumes some ordering op the options
                    # which may not be true
                    t_rw = vol_params[2] ? vol_params[2].split(',')[0].downcase == 'rw' ? true : false : true
                    t_vol = { 'name' => vol_params[0], 'destination' => vol_params[1], 'rw' => t_rw }
                    pp_volumes.append(t_vol)
                else
                    # this next line is fragile and likely to break because it assumes some ordering op the options
                    # which may not be true
                    t_rw = vol_params[2] ? vol_params[2].split(',')[0].downcase == 'rw' ? true : false : true
                    t_bind = { 'source' => vol_params[0], 'destination' => vol_params[1], 'rw' => t_rw }
                    pp_binds.append(t_bind)
                end
            end

            binds = []
            volumes = []
            inspect_hash['Mounts'].map do |mount|
                if mount.fetch('Type').downcase == 'bind'
                    binds.append({ 'source' => mount.fetch('Source'), 'destination' => mount.fetch('Destination'), 'rw' => mount.fetch('RW') })
                elsif mount.fetch('Type').downcase == 'volume'
                    volumes.append({ 'name' => mount.fetch('Name'), 'destination' => mount.fetch('Destination'), 'rw' => mount.fetch('RW') })
                end
            end

            param_changed = true if (pp_binds.length != binds.length && Set.new(pp_binds) != Set.new(binds))
            param_changed = true if (pp_volumes.length > volumes.length && !volumes.subset(pp_volumes))
        elsif opts['osfamily'] == 'windows'
            # going to consider this broken for windows since I cant test this...
            # what we can do is keep the existing logic and hope for the best...
            param_changed = true if opts['volumes'].is_a?(String) && opts['volumes'].scan(%r{(?=:)}).count == 2 && opts['volumes'] != inspect_hash['Mounts'].to_a[0] && opts['osfamily'] == 'windows'
            param_changed = if opts['volumes'].is_a?(String) && opts['volumes'].scan(%r{(?=:)}).count == 1 && opts['volumes'] != inspect_hash['Config']['Volumes'].to_a[0] && opts['osfamily'] == 'windows'
                              true
                            else
                              param_changed
                            end

            pp_paths = opts['volumes'].select { |item| item.scan(%r{(?=:)}).count == 1 } if opts['volumes'].is_a?(Array) && opts['osfamily'] == 'windows'
            pp_mounts = opts['volumes'].select { |item| item.scan(%r{(?=:)}).count == 2 } if opts['volumes'].is_a?(Array) && opts['osfamily'] == 'windows'

            inspect_paths = if inspect_hash['Config']['Volumes']
                              inspect_hash['Config']['Volumes'].keys
                            else
                              []
                            end

            # for the mounts from insepct, if it is a volume, use the volume name
            # otherwise use the source path as the value saved for comparison with the manifest values
            names = inspect_hash['Mounts'].map { |item| item.fetch('Type').downcase == 'volume' ? item.fetch('Name') : item.fetch('Source') } if inspect_hash['Mounts']
            # for the mounts from the manifest, split the entry and use
            pp_names = pp_mounts.map { |item| item.split(':')[0] } if pp_mounts
            # sort both lists for the comparison since we don't know which order they will be in
            param_changed = true if pp_names.sort != names.sort


            destinations = inspect_hash['Mounts'].map { |item| item.fetch('Destination') } if inspect_hash['Mounts']
            # remove inspect_paths volumes that are mounted
            inspect_paths = inspect_paths.reject { |item| destinations.include?(item) }
            pp_destinations = pp_mounts.map { |item| "#{item.split(':')[1].downcase}:#{item.split(':')[2]}" } if pp_mounts && opts['osfamily'] == 'windows'
            destinations = destinations.select { |item| pp_destinations.include?(item) } if destinations && pp_destinations

            param_changed = true if pp_destinations.sort != destinations.sort
            param_changed = true if pp_paths != inspect_paths
            param_changed = true if pp_mounts != [] && inspect_hash['Mounts'].nil?
        end


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
