# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'zlib'

require_relative 'codecs'
require_relative 'crypto/traditional_decrypter'
require_relative 'entry'

##
module Rubyzip
  class EntryInputStream # :nodoc:
    def initialize(io, entry, password = '')
      @io = io
      @crc32 = Zlib.crc32
      @entry = entry
      @output_data_length_warning = false
      @processed_data = 0

      @decompressor = assemble_io(password)
    end

    def eof?
      @decompressor.eof?
    end

    def read(len = nil)
      return (len.nil? || len.zero? ? '' : nil) if eof?

      buf = @decompressor.read(len)
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

    private

    def assemble_io(password)
      decompressor_class = Codecs.decompressor_for_entry(@entry)

      if @entry.encrypted?
        decrypter = Crypto::TraditionalDecrypter.new(@io, password)
        compressed_size = @entry.compressed_size - decrypter.header_size
        decompressor_class.new(decrypter, compressed_size)
      else
        decompressor_class.new(@io, @entry.compressed_size)
      end
    end
  end
end
