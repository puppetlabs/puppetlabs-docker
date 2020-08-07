require 'open3'
require 'json'

module Puppet::Parser::Functions
  # Checks if at least one parammeter is changed
  newfunction(:docker_params_changed, type: :rvalue) do |args|
    opts = args[0] || {}
    return_value = []

    if opts['sanitised_title'] && opts['osfamily']
      stdout, stderr, status = Open3.capture3("docker inspect #{opts['sanitised_title']}")
      if stderr.to_s == '' && status.to_s.include?('exit 0')
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

        return_value << if param_changed
                          'PARAM_CHANGED'
                        else
                          'NO_CHANGE'
                        end
      else
        return_value << 'CONTAINER_NOT_FOUND'
      end
    else
      return_value << 'ARG_REQUIRED_MISSING'
    end

    return_value.flatten.join(' ')
  end
end
