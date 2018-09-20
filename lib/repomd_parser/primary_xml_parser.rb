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
