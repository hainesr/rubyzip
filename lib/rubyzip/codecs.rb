# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip
  # A registry of compression and decompression methods.
  module Codecs
    @decompressors = {}

    def self.register_decompressor(clazz)
      return unless clazz.const_defined?(:DECOMPRESSION_METHOD)

      @decompressors[clazz.const_get(:DECOMPRESSION_METHOD)] = clazz
    end

    def self.decompressor_for(compression_method)
      @decompressors[compression_method]
    end

    def self.decompressor_for_entry(entry)
      decompressor_for(entry.compression_method)
    end
  end
end
