# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'decompressor'

##
module Rubyzip
  module Codecs
    # A pass-through decompressor that handles Stored data.
    class StoredDecompressor < Decompressor
      DECOMPRESSION_METHOD = COMPRESSION_METHOD_STORE # :nodoc:

      def eof?
        @remaining_data <= 0
      end

      private

      def read_stream(len)
        len = @remaining_data if len.nil? || len > @remaining_data

        buf = @io.read(len)
        raise EOFError, 'Unexpected EOF.' if buf.nil?

        @remaining_data -= buf.length
        buf
      end
    end
  end
end
