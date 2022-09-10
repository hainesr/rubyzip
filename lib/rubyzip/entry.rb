# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'constants'
require_relative 'utilities'

##
module Rubyzip
  # Entry represents an entry in a zip file.
  class Entry
    attr_reader :name

    def initialize(name, header: nil)
      raise ArgumentError, 'Entry name cannot be longer than 65,535 characters.' if name.length > 0xFFFF

      @name = name
      @header_data = header
    end

    def compressed_size
      Utilities.read32(@header_data, LOC_OFF_COMP_SIZE) unless @header_data.nil?
    end

    def compression_method
      Utilities.read16(@header_data, LOC_OFF_COMP_METHOD) unless @header_data.nil?
    end

    def crc32
      Utilities.read32(@header_data, LOC_OFF_CRC32) unless @header_data.nil?
    end

    def directory?
      @name.end_with?('/')
    end

    def encrypted?
      test_flag(GP_FLAGS_ENCRYPTED) unless @header_data.nil?
    end

    def mtime
      return if @header_data.nil?

      Utilities.dos_to_ruby_time(Utilities.read32(@header_data, LOC_OFF_MOD_TIME))
    end

    def streamed?
      test_flag(GP_FLAGS_STREAMED) unless @header_data.nil?
    end

    def uncompressed_size
      Utilities.read32(@header_data, LOC_OFF_UNCOMP_SIZE) unless @header_data.nil?
    end

    def utf8?
      test_flag(GP_FLAGS_UTF8) unless @header_data.nil?
    end

    def version_needed_to_extract
      return 10 if @header_data.nil?

      Utilities.read16(@header_data, LOC_OFF_VER_EXTRACT)
    end

    private

    def test_flag(mask)
      (Utilities.read16(@header_data, LOC_OFF_GP_FLAGS) & mask) == mask
    end
  end
end
