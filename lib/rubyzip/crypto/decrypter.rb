# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'zlib'

##
module Rubyzip
  module Crypto # :nodoc:
    # This is the superclass for all decrypters.
    #
    # Subclasses are required to implement `decrypt` and define `HEADER_BYTESIZE`.
    class Decrypter
      def initialize(io)
        @io = io
      end

      def header_size
        self.class.const_get(:HEADER_BYTESIZE)
      end

      def read(len = nil)
        return (len.nil? || len.zero? ? '' : nil) if @io.eof?

        decrypt(@io.read(len))
      end
    end
  end
end
