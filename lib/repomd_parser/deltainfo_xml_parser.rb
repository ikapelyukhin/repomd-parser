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
        arch: @package[:arch]
      )
    end
  end

end
