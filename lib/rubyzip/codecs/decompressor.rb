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
        @processed_data = 0
        @crc32 = Zlib.crc32
        @output_data_length_warning = false
      end

      def read(len = nil)
        return (len.nil? || len.zero? ? '' : nil) if eof?

        buf = read_stream(len)
        @processed_data += buf.length
        if !@output_data_length_warning && (@processed_data > @entry.uncompressed_size)
          @output_data_length_warning = true
          warn "Entry '#{@entry.name}' should be #{@entry.uncompressed_size}B, but is larger when inflated."
        end
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
