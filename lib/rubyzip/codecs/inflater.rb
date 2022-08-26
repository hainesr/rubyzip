# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'decompressor'

require 'zlib'

##
module Rubyzip
  ##
  module Codecs
    # A decompressor for deflated entries.
    class Inflater < Decompressor
      DECOMPRESSION_METHOD = COMPRESSION_METHOD_DEFLATE
      MAX_CHUNK_SIZE = 32_768

      def initialize(io, entry)
        super

        @zlib_inflater = Zlib::Inflate.new(-Zlib::MAX_WBITS)
        @buffer = +''
      end

      def eof?
        @buffer.empty? && @zlib_inflater.finished?
      end

      private

      def read_stream(len)
        while len.nil? || (@buffer.bytesize < len)
          break if @zlib_inflater.finished?

          read_len = [@remaining_data, MAX_CHUNK_SIZE].min
          @buffer << inflate(read_len)
          @remaining_data -= read_len
        end

        @buffer.slice!(0...(len || @buffer.bytesize))
      end

      def inflate(len)
        retried = 0
        begin
          @zlib_inflater.inflate(@io.read(len))
        rescue Zlib::BufError
          raise if retried >= 5 # Seems legit?

          retried += 1
          retry
        end
      end
    end
  end
end
