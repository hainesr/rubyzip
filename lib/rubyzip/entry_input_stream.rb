# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'zlib'

require_relative 'codecs'
require_relative 'crypto/traditional_decrypter'
require_relative 'entry'
require_relative 'errors'

##
module Rubyzip
  class EntryInputStream # :nodoc:
    # :nodoc:
    def initialize(io, entry, password = '')
      @io = io
      @crc32 = Zlib.crc32
      @entry = entry
      @output_data_length_warning = false
      @processed_data = 0

      @decompressor = assemble_io(password)
    end

    # :nodoc:
    def eof?
      @decompressor.eof?
    end

    # :nodoc:
    def read(len = nil) # rubocop:disable Metrics
      return (len.nil? || len.zero? ? '' : nil) if eof?

      buf = @decompressor.read(len)
      @processed_data += buf.length
      if !@output_data_length_warning && (@processed_data > @entry.uncompressed_size)
        error = EntrySizeError.new(@entry)
        raise error if Rubyzip.error_on_invalid_entry_size

        @output_data_length_warning = true
        warn "WARNING: #{error.message}"
      end
      @crc32 = Zlib.crc32(buf, @crc32)

      @entry.update_streaming_data(Utilities.read_streaming_header(@io)) if eof? && @entry.streamed?

      buf
    end

    # :nodoc:
    def valid_crc32?
      @entry.crc32 == @crc32
    end

    # :nodoc:
    def validate_crc32!
      return if valid_crc32?

      error = CRC32Error.new(@entry.crc32, @crc32)
      raise error if Rubyzip.error_on_invalid_crc32

      warn "WARNING: #{error.message}"
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
