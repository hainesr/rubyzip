# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../constants'

##
module Rubyzip
  module Codecs
    # This is the superclass for all decompressors.
    #
    # Subclasses are required to implement `read_stream` and `eof?`.
    class Decompressor
      def initialize(io, data_length) # :nodoc:
        @io = io
        @remaining_data = data_length
      end

      # :call-seq:
      #   read -> String
      #   read(length) -> String
      #
      # Read from this decompressor's IO stream, decompressing data on
      # the fly. Upto `length` bytes are returned, or fewer if the end of
      # the stream is reached first. If `length` is not provided then the
      # whole, or rest of, the stream is decompressed.
      def read(len = nil)
        return (len.nil? || len.zero? ? '' : nil) if eof?

        read_stream(len)
      end
    end
  end
end
