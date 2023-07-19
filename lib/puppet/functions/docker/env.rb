# frozen_string_literal: true

Puppet::Functions.create_function(:'docker::env') do
  dispatch :env do
    param 'Array', :args
    return_type 'Array'
  end

  def env(args)
    args
  end
end
