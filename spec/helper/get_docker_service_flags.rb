# frozen_string_literal: true

require 'shellwords'

def get_docker_service_flags(args)
  flags = []

  if args['service_name'] && args['service_name'].to_s != 'undef'
    flags << "'#{args['service_name']}'"
  end

  if args['detach'].to_s != 'false'
    flags << '--detach'
  end

  if args['env'].is_a? Array
    args['env'].each do |env|
      flags << "--env '#{env}'"
    end
  end

  if args['label'].is_a? Array
    args['label'].each do |label|
      flags << "--label #{label}"
    end
  end

  if args['mounts'].is_a? Array
    args['mounts'].each do |mount|
      flags << "--mount #{mount}"
    end
  end

  if args['networks'].is_a? Array
    args['networks'].each do |network|
      flags << "--network #{network}"
    end
  end

  if args['publish'].is_a? Array
    args['publish'].each do |port|
      flags << "--publish #{port}"
    end
  elsif args['publish'] && args['publish'].to_s != 'undef'
    flags << "--publish '#{args['publish']}'"
  end

  if args['replicas'] && args['replicas'].to_s != 'undef'
    flags << "--replicas '#{args['replicas']}'"
  end

  if args['tty'].to_s != 'false'
    flags << '--tty'
  end

  if args['user'] && args['user'].to_s != 'undef'
    flags << "--user '#{args['user']}'"
  end

  if args['workdir'] && args['workdir'].to_s != 'undef'
    flags << "--workdir '#{args['workdir']}'"
  end

  if args['extra_params'].is_a? Array
    args['extra_params'].each do |param|
      flags << param
    end
  end

  if args['host_socket'] && args['host_socket'].to_s != 'undef'
    flags << "-H '#{args['host_socket']}'"
  end

  if args['registry_mirror'].is_a? Array
    args['registry_mirror'].each do |param|
      flags << "--registry-mirror='#{param}'"
    end
  elsif args['registry_mirror'] && args['registry_mirror'].to_s != 'undef'
    flags << "--registry-mirror='#{args['registry_mirror']}'"
  end

  if args['image'] && args['image'].to_s != 'undef'
    flags << "'#{args['image']}'"
  end

  if args['command'].is_a? Array
    flags << args['command'].join(' ')
  elsif args['command'] && args['command'].to_s != 'undef'
    flags << args['command'].to_s
  end

  flags.flatten.join(' ')
end
