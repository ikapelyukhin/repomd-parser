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
  def start_element(name, attrs = [])
    @current_node = name.to_sym
    case name
    when 'package'
      @package = {}
    when 'version'
      @package[:version] = get_attribute(attrs, 'ver')
      @package[:release] = get_attribute(attrs, 'rel')
    when 'location'
      @package[:location] = get_attribute(attrs, 'href')
    when 'checksum'
      @package[:checksum_type] = get_attribute(attrs, 'type')
    when 'size'
      @package[:size] = get_attribute(attrs, 'package').to_i
    when 'time'
      @package[:build_time] = get_attribute(attrs, 'build')
    end
  end

  def characters(string)
    return unless %i[name arch checksum summary description rpm:license].include? @current_node

    @package[@current_node] ||= ''
    @package[@current_node] += string.strip
  end

  def end_element(name)
    return unless name == 'package'

    @referenced_files << RepomdParser::Reference.new(
      location: @package[:location],
      checksum_type: @package[:checksum_type],
      checksum: @package[:checksum],
      type: :rpm,
      size: @package[:size].to_i,
      arch: @package[:arch],
      version: @package[:version],
      release: @package[:release],
      name: @package[:name],
      summary: @package[:summary],
      description: @package[:description],
      license: @package[:'rpm:license'],
      build_time: Time.at(@package[:build_time].to_i).utc
    )
  end
end
