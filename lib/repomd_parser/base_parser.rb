# repomd_parser -- Ruby gem to parse RPM repository metadata
# Copyright (C) 2018  Ivan Kapelyukhin, SUSE Linux GmbH
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

require 'nokogiri'
require 'zlib'

class RepomdParser::BaseParser < Nokogiri::XML::SAX::Document
  def initialize(filename)
    super()
    @referenced_files = []
    @filename = filename
  end

  def parse
    Nokogiri::XML::SAX::Parser.new(self).parse(file_io_class.open(@filename))
    @referenced_files
  end

  protected

  def file_io_class
    case File.extname(@filename)
    when '.gz' then Zlib::GzipReader
    when '.zst' then RepomdParser::ZstdReader
    else File
    end
  end

  def get_attribute(attributes, name)
    attributes.select { |e| e[0] == name }.first[1]
  end
end
