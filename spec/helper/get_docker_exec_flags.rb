# frozen_string_literal: true

def get_docker_exec_flags(args)
  flags = []

  flags << '--detach=true' if args['detach']

  flags << '--interactive=true' if args['interactive']

  flags << '--tty=true' if args['tty']

  unless args['env'].empty?
    args['env'].each do |namevaluepair|
      flags << "--env #{namevaluepair}"
    end
  end

  flags.flatten.join(' ')
end
