# frozen_string_literal: true

require 'open3'
require 'json'

module DockerCheckChanges
  DEBUG = ENV['DOCKER_CHECK_DEBUG'] || false
  class Base
    attr_accessor :return_value,
                  :stdout,
                  :err,
                  :status
    def initialize
      @return_value = 'No changes detected'
      @status = true
    end
    def debug(message)
      Puppet.warning message if DEBUG
    end
    def gen_message(method, old, new)
      m = []
      m << "#{method}"
      m << "Old value: #{old}"
      m << "New value: #{new}"
      m.join("\n")
    end
    def run(cmd, failonfail = true)
      @stdout = Puppet::Util::Execution.execute(cmd, {:failonfail => failonfail})
      @status = @stdout.exitstatus
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
      }.flatten.sort
      pp_ports = [opts['ports']].flatten.sort

      debug gen_message(__method__,ports,pp_ports)
      return true if pp_ports != ports
      debug "Don't have changes"
      false
    end
    def image_changed?(opts, hash)
      debug gen_message(__method__,hash['Config']['Image'],opts['image'])
      return true if opts['image'] && opts['image'] != hash['Config']['Image']
      debug "Don't have changes"
      false
    end
    def volumes_changed?(opts, hash)
      inspect_volumes = []
      volumes = get_volumes(opts['volumes'])
      inspect_volumes = hash['Config']['Volumes'].keys.sort if hash['Config']['Volumes']
      debug gen_message(__method__,inspect_volumes,volumes)
      return true if volumes != inspect_volumes
      debug "Don't have changes"
      false
    end
    def binds_changed?(opts, hash)
      binds = get_binds(opts['volumes'])
      binds_hash = [hash['HostConfig']['Binds']].flatten.sort
      debug gen_message(__method__,binds_hash,binds)
      return true if binds != binds_hash
      return true if binds != [] && hash['HostConfig'].nil?
      debug "Don't have changes"
      false
    end
    def has_changes?(opts, hash)
      return true if image_changed?(opts, hash)
      return true if volumes_changed?(opts, hash)
      return true if binds_changed?(opts, hash)
      return true if port_changed?(opts, hash)
      false
    end
  end
  class Linux < Base; end
  class Windows < Base
    def run(cmd, failonfail = true)
      @stdout = Puppet::Util::Execution.execute("powershell.exe -Command \"& {#{cmd}}\" ", {:failonfail => failonfail})
      @status = @stdout.exitstatus
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

    if opts['sanitised_title']
      @console.run("docker inspect #{opts['sanitised_title']}", false)
      if @console.status == 0
        param_changed = @console.has_changes?(opts, JSON.parse(@console.stdout)[0])

        @console.restart_container(
          opts['sanitised_title'],
          opts['stop_wait_time'],
          opts['cidfile'],
          opts['command'],
          opts['image']) if param_changed
      else
        @console.create_container(opts['command'], opts['image']) unless File.exist?(opts['cidfile'])
        @console.run("docker inspect #{opts['sanitised_title']}", false)
        unless @console.status == 0
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
