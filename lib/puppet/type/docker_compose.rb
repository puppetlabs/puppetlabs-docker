Puppet::Type.newtype(:docker_compose) do
  @doc = 'A type representing a Docker Compose file'

  ensurable

  def refresh
    provider.restart
  end

  newparam(:name) do
    desc 'Docker compose file path.'
  end

  newparam(:scale) do
    desc 'A hash of compose services and number of containers.'
    validate do |value|
      raise _('scale should be a Hash') unless value.is_a? Hash
      unless value.all? { |k, _v| k.is_a? String }
        raise _('The name of the compose service in scale should be a String')
      end
      unless value.all? { |_k, v| v.is_a? Integer }
        raise _('The number of containers in scale should be an Integer')
      end
    end
  end

  newparam(:options) do
    desc 'Additional options to be passed directly to docker-compose.'
    validate do |value|
      raise _('options should be a String') unless value.is_a? String
    end
  end

  newparam(:up_args) do
    desc 'Arguments to be passed directly to docker-compose up.'
    validate do |value|
      raise _('up_args should be a String') unless value.is_a? String
    end
  end

  autorequire(:file) do
    self[:name]
  end
end
