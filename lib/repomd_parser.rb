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

require 'repomd_parser/version'
require 'repomd_parser/reference'
require 'repomd_parser/base_parser'
require 'repomd_parser/repomd_xml_parser'
require 'repomd_parser/deltainfo_xml_parser'
require 'repomd_parser/primary_xml_parser'
require 'repomd_parser/zstd_reader'

require 'zlib'
require 'bzip2/ffi'

module RepomdParser
  def self.decompress_io(io_object, filename)
    case File.extname(filename)
    when '.gz' then Zlib::GzipReader.new(io_object)
    when '.zst' then RepomdParser::ZstdReader.new(io_object)
    when '.bz2' then Bzip2::FFI::Reader.open(io_object)
    else io_object
    end
  end
end
