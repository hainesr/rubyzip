# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip
  # A registry of compression and decompression methods.
  module Codecs
    @decompressors = {}

    # :call-seq:
    #   register_decompressor(class)
    #
    # Register a decompressor that can be used by Rubyzip to extract an
    # entry from a Zip archive. To be registered as a decompressor, a
    # class should at least provide the constant `DECOMPRESSION_METHOD`,
    # which should correspond to one of the decompression methods listed
    # in the Zip standard.
    def self.register_decompressor(clazz)
      return unless clazz.const_defined?(:DECOMPRESSION_METHOD)

      @decompressors[clazz.const_get(:DECOMPRESSION_METHOD)] = clazz
    end

    def self.decompressor_for(compression_method) # :nodoc:
      @decompressors[compression_method]
    end

    def self.decompressor_for_entry(entry) # :nodoc:
      decompressor_for(entry.compression_method)
    end
  end
end

require_relative 'codecs/decompressors'
