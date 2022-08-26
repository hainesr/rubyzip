# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'zlib'

require_relative '../constants'

##
module Rubyzip
  module Codecs
    # This is the superclass for all decompressors.
    #
    # It calculates a CRC-32 checksum as it decompresses, which can
    # be validated.
    #
    # Subclasses are required to implement `read_stream` and `eof?`.
    class Decompressor
      def initialize(io, entry)
        @io = io
        @entry = entry
        @remaining_data = @entry.compressed_size
        @crc32 = Zlib.crc32
      end

      def read(len = nil)
        return (len.nil? || len.zero? ? '' : nil) if eof?

        buf = read_stream(len)
        @crc32 = Zlib.crc32(buf, @crc32)

        buf
      end

      def valid_crc32?
        @entry.crc32 == @crc32
      end

      def validate_crc32!
        raise CRC32Error.new(@entry.crc32, @crc32) unless valid_crc32?
      end
    end
  end
end
