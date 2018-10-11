Puppet::Type.newtype(:docker_config) do
  @doc = 'A type representing a Docker config'
  ensurable

  newparam(:name) do
    isnamevar
    desc 'The name of the config'
  end

  newproperty(:file) do
    desc 'The file with the content of the config'
  end

  newproperty(:id) do
    desc 'The ID of the config provided by Docker'
    validate do |value|
      raise(Puppet::ParseError, "#{value} is read-only and is only available via puppet resource.")
    end
  end
end
