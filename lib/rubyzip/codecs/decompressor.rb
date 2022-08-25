# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../constants'

##
module Rubyzip
  module Codecs
    # This is the superclass for all decompressors. Subclasses are required
    # to implement `read_stream` and `eof?`.
    class Decompressor
      def initialize(io, entry)
        @io = io
        @entry = entry
      end

      def read(len = nil)
        return (len.nil? || len.zero? ? '' : nil) if eof?

        read_stream(len)
      end
    end
  end
end
