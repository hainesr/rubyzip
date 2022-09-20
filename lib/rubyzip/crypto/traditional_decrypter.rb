# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'zlib'

require_relative 'decrypter'

##
module Rubyzip
  module Crypto # :nodoc:
    # A decrypter that implements 'traditional' Zip encryption.
    class TraditionalDecrypter < Decrypter
      HEADER_BYTESIZE = 12 # :nodoc:

      # :call-seq:
      #   new(io, password) -> TraditionalDecrypter
      #
      # Creates a new decrypter for the Zip "traditional" encryption
      # algorithm. `io` is an IO-like object from which data will be
      # read and decrypted.
      def initialize(io, password)
        super(io)

        @key0 = 0x12345678
        @key1 = 0x23456789
        @key2 = 0x34567890
        password.each_byte do |byte|
          update_keys(byte.chr)
        end

        @io.read(HEADER_BYTESIZE).each_byte { |x| decode(x) }
      end

      private

      def decode(num)
        num ^= decrypt_byte
        update_keys(num.chr)
        num
      end

      def decrypt(data)
        data.unpack('C*').map { |x| decode(x) }.pack('C*')
      end

      def decrypt_byte
        temp = (@key2 & 0xffff) | 2
        ((temp * (temp ^ 1)) >> 8) & 0xff
      end

      def update_keys(num)
        @key0 = ~Zlib.crc32(num, ~@key0)
        @key1 = (((@key1 + (@key0 & 0xff)) * 134_775_813) + 1) & 0xffffffff
        @key2 = ~Zlib.crc32((@key1 >> 24).chr, ~@key2)
      end
    end
  end
end
