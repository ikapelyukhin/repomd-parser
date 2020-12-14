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

class RepomdParser::UpdateinfoXmlParser < RepomdParser::BaseParser

  def initialize(filename)
    @updates = []
    super(filename)
  end

  def parse
    super
    @updates
  end

  def start_element(name, attrs = [])
    @current_node = name.to_sym
    if (name == 'update')
      @update = {}
      @update[:type] = get_attribute(attrs, 'type')
      @update[:version] = get_attribute(attrs, 'version')
    elsif (name == 'issued')
      @update[:issued] = get_attribute(attrs, 'date')
    elsif (name == 'package')
      @package = {}
      @package[:name] = get_attribute(attrs, 'name')
      @package[:version] = get_attribute(attrs, 'version')
      @package[:release] = get_attribute(attrs, 'release')
      @package[:arch] = get_attribute(attrs, 'arch')
    elsif (name == 'sum')
      @package[:checksum_type] = get_attribute(attrs, 'type')
    end
  end

  def characters(string)
    if (%i[id title description severity].include? @current_node)
      @update[@current_node] ||= ''
      @update[@current_node] += string.strip
    elsif (@current_node == :sum)
      @package[:checksum] ||= ''
      @package[:checksum] += string.strip
    elsif (@current_node == :filename)
      @package[:location] ||= ''
      @package[:location] += string.strip
    end
  end

  def end_element(name)
    if (name == 'update')
      @updates << RepomdParser::Update.new(
        id: @update[:id],
        title: @update[:title],
        description: @update[:description],
        severity: @update[:severity],
        type: @update[:type],
        version: @update[:version],
        issued: Time.at(@update[:issued].to_i),
        packages: @referenced_files
      )
      @referenced_files = []
    elsif (name == 'package')
      @referenced_files << RepomdParser::Reference.new(
        location: @package[:location],
        checksum_type: @package[:checksum_type],
        checksum: @package[:checksum],
        type: :rpm,
        size: nil,
        arch: @package[:arch],
        version: @package[:version],
        release: @package[:release],
        name: @package[:name],
      )
    end
  end

end
