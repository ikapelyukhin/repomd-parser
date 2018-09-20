class RepomdParser::RepomdXmlParser

  def initialize(filename)
    @filename = filename
  end

  def parse
    files = []
    xml = Nokogiri::XML(File.open(@filename))

    xml.xpath('/xmlns:repomd/xmlns:data').each do |data_node|
      type = data_node.attr('type').to_sym

      hash = {}
      data_node.xpath('./*').each do |node|
        hash[node.name.to_sym] = { value: node.text.to_s }

        node.attributes.each do |name, attr|
          hash[node.name.to_sym][name.to_sym] = attr.value
        end
      end

      files << RepomdParser::Reference.new(
        location: hash[:location][:href],
        checksum_type: hash[:checksum][:type],
        checksum: hash[:checksum][:value],
        type: type,
        size: hash[:size][:value].to_i
      )
    end

    files
  end

end
