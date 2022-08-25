# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'decompressor'

##
module Rubyzip
  module Codecs
    class StoredDecompressor < Decompressor
      DECOMPRESSION_METHOD = COMPRESSION_METHOD_STORE

      def initialize(io, entry)
        super

        @remaining = @entry.uncompressed_size
      end

      def eof?
        @remaining <= 0
      end

      private

      def read_stream(len)
        len = @remaining if len.nil? || len > @remaining

        buf = @io.read(len)
        raise EOFError, 'Unexpected EOF.' if buf.nil?

        @remaining -= buf.length
        buf
      end
    end
  end
end
