class RepomdParser::PrimaryXmlParser < RepomdParser::BaseParser

  def initialize(filename, mirror_src = false)
    super(filename)
    @mirror_src = mirror_src
  end

  def start_element(name, attrs = [])
    @current_node = name.to_sym
    if (name == 'package')
      @package = {}
    elsif (name == 'version')
      @package[:version] = get_attribute(attrs, 'ver')
    elsif (name == 'location')
      @package[:location] = get_attribute(attrs, 'href')
    elsif (name == 'checksum')
      @package[:checksum_type] = get_attribute(attrs, 'type')
    elsif (name == 'size')
      @package[:size] = get_attribute(attrs, 'package').to_i
    end
  end

  def characters(string)
    if (%i[name arch checksum].include? @current_node)
      @package[@current_node] ||= ''
      @package[@current_node] += string.strip
    end
  end

  def end_element(name)
    if (name == 'package')
      unless (@package[:arch] == 'src' && !@mirror_src)
        @referenced_files << RepomdParser::Reference.new(
          location: @package[:location],
          checksum_type: @package[:checksum_type],
          checksum: @package[:checksum],
          type: :rpm,
          size: @package[:size].to_i,
          arch: @package[:arch],
        )
      end
    end
  end

end
