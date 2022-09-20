# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
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
      def initialize(io) # :nodoc:
        @io = io
      end

      # :call-seq:
      #   header_size -> Integer
      #
      # Return the size, in bytes, of the decryption header at the start of
      # the encrypted stream.
      def header_size
        self.class.const_get(:HEADER_BYTESIZE)
      end

      # :call-seq:
      #   read -> String
      #   read(length) -> String
      #
      # Read from this decrypter's IO stream, decrypting data on the fly.
      # Upto `length` bytes are returned, or fewer if the end of
      # the stream is reached first. If `length` is not provided then the
      # whole, or rest of, the stream is decrypted.
      def read(len = nil)
        return (len.nil? || len.zero? ? '' : nil) if @io.eof?

        decrypt(@io.read(len))
      end
    end
  end
end
