# frozen_string_literal: true

def get_docker_exec_flags(args)
  flags = []

  if args['detach']
    flags << '--detach=true'
  end

  if args['interactive']
    flags << '--interactive=true'
  end

  if args['tty']
    flags << '--tty=true'
  end

  unless args['env'].empty?
    args['env'].each do |namevaluepair|
      flags << "--env #{namevaluepair}"
    end
  end

  flags.flatten.join(' ')
end
