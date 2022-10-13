# frozen_string_literal: true

require 'open3'
require 'json'

module DockerCheckChanges
  class Base
    attr_accessor :return_value,
                  :stdout,
                  :err,
                  :status
    def initialize
      @return_value = 'No changes detected'
    end
    def run(cmd)
      @stdout, @err, @status = Open3.capture3(cmd)
      Puppet.err @err unless @status.success?
    end
    def delete_command(file)
      run "rm -f #{file}"
    end
    def start_command(name)
      run "docker start #{name}"
    end
    def stop_command(name, time = 10)
      run "docker stop --time=#{time} #{name}"
    end
    def remove_command(name)
      run "docker rm -v #{name}"
    end
    def pull_command(image)
      run "docker pull #{image} -q"
    end
    def inspect_command(title)
      run "docker inspect #{title}"
    end
    def create_container(cmd, image)
      pull_command(image)
      run(cmd)
    end
    def restart_container(name, stop_wait_time, cidfile, cmd, image)
      stop_command(name, stop_wait_time)
      remove_command(name)
      delete_command(cidfile)
      pull_command(image)
      run(cmd)
      @return_value = 'Param changed'
    end

    def get_volumes(volumes)
      [volumes].flatten.reject {|i| i.include?(':')}.sort
    end
    def get_binds(volumes)
      [volumes].flatten.select {|i| i.include?(':')}.sort
    end
    def port_changed?(opts, hash)
      ports = hash['HostConfig']['PortBindings'].map { |key, item|
        item.map {|pair|
          [pair['HostIp'], pair['HostPort'], key.split('/')[0]].reject {
            |c| c.empty?
          }.join(':')
        }
      }.flatten
      pp_ports = [opts['ports']].flatten.sort if opts['ports']

      true if pp_ports && pp_ports != ports
    end
    def has_changes?(opts, hash)
      inspect_volumes = []

      return true if opts['image'] && opts['image'] != hash['Config']['Image']

      volumes = get_volumes(opts['volumes'])
      inspect_volumes = hash['Config']['Volumes'].keys.sort if hash['Config']['Volumes']
      return true if volumes != inspect_volumes

      binds = get_binds(opts['volumes'])
      binds_hash  = hash['Mounts'].map do |item|
        if item['Type'] == 'bind'
          "#{item['Source']}:#{item['Destination']}"
        else
          next
        end
      end.compact.sort if hash['Mounts']
      return true if binds != binds_hash

      return true if binds != [] && hash['Mounts'].nil?
      return true if port_changed?(opts, hash)

      false
    end
  end
  class Linux < Base; end
  class Windows < Base
    def run(cmd)
      @stdout, @err, @status = Open3.capture3("powershell.exe -Command \"& {#{cmd}}\" ")
      Puppet.err @err unless @status.success?
    end
    def delete_command(file)
      run "del #{file}"
    end
    def get_volumes(volumes)
      [volumes].flatten.reject {|i| i.scan(%r{(?=:)}).count == 1 }.sort
    end
    def get_binds(volumes)
      [volumes].flatten.reject {|i| i.scan(%r{(?=:)}).count == 2 }.sort
    end
  end
end

Puppet::Functions.create_function(:docker_params_changed) do
  dispatch :detect_changes do
    param 'Hash', :opts
    return_type 'String'
  end

  def detect_changes(opts)
    return 'Arg osfamily is missing' unless opts['osfamily']

    case opts['osfamily']
    when 'windows'
      @console = DockerCheckChanges::Windows.new
    else
      @console = DockerCheckChanges::Base.new
    end
    @console.return_value = 'No changes detected'

    if opts['sanitised_title']
      @console.inspect_command(opts['sanitised_title'])
      if @console.status.success?
        param_changed = @console.has_changes?(opts, JSON.parse(@console.stdout)[0])

        @console.restart_container(
          opts['sanitised_title'],
          opts['stop_wait_time'],
          opts['cidfile'],
          opts['command'],
          opts['image']) if param_changed
      else
        @console.create_container(opts['command'], opts['image']) unless File.exist?(opts['cidfile'])
        @console.inspect_command(opts['sanitised_title'])
        unless @console.status.success?
          @console.delete_command(opts['cidfile'])
          @console.create_container(opts['command'], opts['image'])
        end
        @console.return_value = 'No changes detected'
      end
    end

    if opts['container_running']
      @console.start_command(opts['sanitised_title'])
    else
      @console.stop_command(opts['sanitised_title'])
    end

    @console.return_value
  end
end
