# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'decompressor'

require 'zlib'

##
module Rubyzip
  module Codecs
    class Inflater < Decompressor
      DECOMPRESSION_METHOD = COMPRESSION_METHOD_DEFLATE
      CHUNK_SIZE = 32_768

      def initialize(io, entry)
        super

        @zlib_inflater = Zlib::Inflate.new(-Zlib::MAX_WBITS)
        @buffer = +''
        @eof = false
      end

      def eof?
        @buffer.empty? && @zlib_inflater.finished?
      end

      def read(len = nil)
        return (len.nil? || len.zero? ? '' : nil) if eof?

        while len.nil? || (@buffer.bytesize < len)
          break if @zlib_inflater.finished?

          @buffer << inflate
        end

        @buffer.slice!(0...(len || @buffer.bytesize))
      end

      private

      def inflate
        retried = 0
        begin
          @zlib_inflater.inflate(@io.read(CHUNK_SIZE))
        rescue Zlib::BufError
          raise if retried >= 5 # Seems legit?

          retried += 1
          retry
        end
      end
    end

    Codecs.register_decompressor(Inflater)
  end
end
