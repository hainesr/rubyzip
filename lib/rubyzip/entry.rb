# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'constants'

##
module Rubyzip
  # Entry represents an entry in a zip file.
  class Entry
    attr_reader :compression_method, :compressed_size, :crc32, :name, :uncompressed_size

    def initialize(name, header = nil)
      if name.bytesize > LIMIT_ENTRY_NAME_SIZE
        raise ArgumentError, "Entry name cannot be larger than #{LIMIT_ENTRY_NAME_SIZE} bytes."
      end

      @name = name

      return unless header

      _sig, @version_needed_to_extract, _fs_type, @gp_flags, @compression_method,
      _last_mod_time, _last_mod_date, @crc32, @compressed_size, @uncompressed_size,
      _name_len, _extra_len = header.unpack(LOC_PACK)
    end

    def directory?
      @name.end_with?('/')
    end

    def encrypted?
      @gp_flags & GP_FLAGS_ENCRYPTED == GP_FLAGS_ENCRYPTED
    end

    def streamed?
      @gp_flags & GP_FLAGS_STREAMED == GP_FLAGS_STREAMED
    end

    def utf8?
      @gp_flags & GP_FLAGS_UTF8 == GP_FLAGS_UTF8
    end

    def version_needed_to_extract
      @version_needed_to_extract || 10
    end
  end
end
