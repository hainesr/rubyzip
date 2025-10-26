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
      DECOMPRESSION_METHOD = COMPRESSION_METHOD_DEFLATE # :nodoc:
      MAX_CHUNK_SIZE = 32_768 # :nodoc:

      # :call-seq:
      #   new(io, data_length) -> Inflater
      #
      # Create a new decompressor for the Inflate algorithm. `io` is an
      # IO-like object from which data will be read and decompressed.
      # `data_length` tell the decompressor how much data should be read
      # from the stream in total, to decompress it entirely.
      def initialize(io, data_length)
        super

        @zlib_inflater = Zlib::Inflate.new(-Zlib::MAX_WBITS)
        @buffer = +''
      end

      # :call-seq:
      #   eof? -> true or false
      #
      # Have we reached the end of this stream?
      def eof?
        @buffer.empty? && @zlib_inflater.finished?
      end

      private

      def read_stream(len)
        while len.nil? || (@buffer.bytesize < len)
          break if @zlib_inflater.finished?

          read_len = [@remaining_data, MAX_CHUNK_SIZE].min
          @buffer << (read_len.zero? ? crawl_inflate : inflate(read_len))
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

      # This method reads a byte at a time in an attempt to cope with
      # streamed entries. If we go any quicker we might read too much,
      # and if we read too much then we've broken our stream if it
      # doesn't support seek (say, we're streaming).
      def crawl_inflate
        buf = +''

        buf << @zlib_inflater.inflate(@io.read(1)) until @zlib_inflater.finished?

        buf
      end
    end
  end
end
