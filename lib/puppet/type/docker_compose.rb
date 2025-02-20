# frozen_string_literal: true

Puppet::Type.newtype(:docker_compose) do
  @doc = 'A type representing a Docker Compose file'

  ensurable

  def refresh
    provider.restart
  end

  newparam(:scale) do
    desc 'A hash of compose services and number of containers.'
    validate do |value|
      raise _('scale should be a Hash') unless value.is_a? Hash
      raise _('The name of the compose service in scale should be a String') unless value.all? { |k, _v| k.is_a? String }
      raise _('The number of containers in scale should be an Integer') unless value.all? { |_k, v| v.is_a? Integer }
    end
  end

  newparam(:options) do
    desc 'Additional options to be passed directly to docker-compose.'
    validate do |value|
      raise _('options should be an Array') unless value.is_a? Array
    end
  end

  newparam(:up_args) do
    desc 'Arguments to be passed directly to docker-compose up.'
    validate do |value|
      raise _('up_args should be a String') unless value.is_a? String
    end
  end

  newparam(:compose_files, array_matching: :all) do
    desc 'An array of Docker Compose Files paths.'
    validate do |value|
      raise _('compose files should be an array') unless value.is_a? Array
    end
  end

  newparam(:name) do
    isnamevar
    desc 'The name of the project'
  end

  newparam(:tmpdir) do
    desc "Override the temporary directory used by docker-compose.

    This property is useful when the /tmp directory has been mounted
    with the noexec option. Or is otherwise being prevented  It allows the module consumer to redirect
    docker-composes temporary files to a known directory.

    The directory passed to this property must exist and be accessible
    by the user that is executing the puppet agent.
    "
    validate do |value|
      raise _('tmpdir should be a String') unless value.is_a? String
    end
  end
end
