require 'nokogiri'
require 'zlib'

class RepomdParser::BaseParser < Nokogiri::XML::SAX::Document

  def initialize(filename)
    @referenced_files = []
    @filename = filename
  end

  def parse
    if (File.extname(@filename) == '.gz')
      Zlib::GzipReader.open(@filename) do |gz|
        Nokogiri::XML::SAX::Parser.new(self).parse(gz)
      end
    else
      File.open(@filename) do |fh|
        Nokogiri::XML::SAX::Parser.new(self).parse(fh)
      end
    end

    @referenced_files
  end

  protected

  def get_attribute(attributes, name)
    attributes.select { |e| e[0] == name }.first[1]
  end

end
