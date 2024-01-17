# repomd_parser -- Ruby gem to parse RPM repository metadata
# Copyright (C) 2024 Ivan Kapelyukhin
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

require 'zstd-ruby'

class RepomdParser::ZstdReader < File
  def initialize(*args)
    super(*args)
    @stream = Zstd::StreamingDecompress.new
    @buffer = ''
  end

  def read(len = nil, out = nil)
    @buffer << @stream.decompress(super(len)) while @buffer.size < len && !eof

    if @buffer.size > len
      out = @buffer[0..len]
      @buffer = @buffer[len..-1]
    else
      out = @buffer
      @buffer = ''
    end

    out
  end
end
