class RepomdParser::DeltainfoXmlParser < RepomdParser::BaseParser

  def initialize(filename)
    super(filename)
  end

  def start_element(name, attrs = [])
    @current_node = name.to_sym
    if (name == 'newpackage')
      @package = {}
      @package[:version] = get_attribute(attrs, 'version')
      @package[:name] = get_attribute(attrs, 'name')
      @package[:arch] = get_attribute(attrs, 'arch')
    elsif (name == 'delta')
      @delta = {}
    elsif (name == 'checksum')
      @delta[:checksum_type] = get_attribute(attrs, 'type')
    end
  end

  def characters(string)
    if (@current_node == :filename)
      @delta[:location] ||= ''
      @delta[:location] += string.strip
    elsif (@current_node == :checksum)
      @delta[:checksum] ||= ''
      @delta[:checksum] += string.strip
    elsif (@current_node == :size)
      @delta[:size] ||= ''
      @delta[:size] += string.strip
    end
  end

  def end_element(name)
    if (name == 'delta')
      @referenced_files << RepomdParser::Reference.new(
        location: @delta[:location],
        checksum_type: @delta[:checksum_type],
        checksum: @delta[:checksum],
        type: :drpm,
        size: @delta[:size].to_i,
        arch: @package[:arch],
      )
    end
  end

end
