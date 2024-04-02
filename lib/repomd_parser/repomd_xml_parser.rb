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

class RepomdParser::RepomdXmlParser
  def parse_file(filename)
    File.open(filename) do |fh|
      parse(fh)
    end
  end

  def parse(io_object)
    files = []
    xml = Nokogiri::XML(io_object)

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
        size: hash[:size] ? hash[:size][:value].to_i : nil
      )
    end

    files
  end
end
