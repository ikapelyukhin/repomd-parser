class RepomdParser::Reference
  attr_accessor :location, :checksum_type, :checksum, :type, :size, :arch

  def initialize(location:, checksum_type:, checksum:, type:, size:, arch: nil)
    local_variables.each do |local_var|
      method = "#{local_var}="
      send(method, binding.local_variable_get(local_var)) if (respond_to?(method))
    end
  end

  # Overloaded comparator for specs
  def ==(obj)
    result = true
    instance_variables.each do |instance_var|
      result &&= (instance_variable_get(instance_var) == obj.instance_variable_get(instance_var))
    end
    result
  end
end
