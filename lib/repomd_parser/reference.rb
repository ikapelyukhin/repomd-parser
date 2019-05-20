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

class RepomdParser::Reference
  attr_accessor :location,
                :checksum_type,
                :checksum,
                :type,
                :size,
                :arch,
                :version,
                :release,
                :name,
                :build_time

  def initialize(location:,
                 checksum_type:,
                 checksum:,
                 type:,
                 size:,
                 arch: nil,
                 version: nil,
                 release: nil,
                 name: nil,
                 build_time: nil)
    local_variables.each do |local_var|
      method = "#{local_var}="
      send(method, binding.local_variable_get(local_var)) if (respond_to?(method))
    end
  end

  # Overloaded comparator for specs
  def ==(obj)
    result = true
    instance_variables.each do |instance_var|
      result &&= (instance_variable_get(instance_var) == obj.instance_variable_get(instance_var))
    end
    result
  end
end
