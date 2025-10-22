# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'constants'
require_relative 'utilities'

##
module Rubyzip
  # Entry represents an entry in a zip file.
  class Entry
    NAME_TOO_LONG_MESSAGE =
      "Entry name cannot be longer than #{LIMIT_ENTRY_NAME_SIZE} characters " \
      "or larger than #{LIMIT_ENTRY_NAME_SIZE} bytes.".freeze

    attr_reader :compression_method, :compressed_size, :crc32, :mtime, :name, :uncompressed_size

    def initialize(name, header = nil)
      raise ArgumentError, NAME_TOO_LONG_MESSAGE if name.bytesize > LIMIT_ENTRY_NAME_SIZE

      @name = name

      return unless header

      _sig, @version_needed_to_extract, _fs_type, @gp_flags, @compression_method,
      last_mod_time, last_mod_date, @crc32, @compressed_size, @uncompressed_size,
      _name_len, _extra_len = header.unpack(LOC_PACK)

      @mtime = Utilities.dos_to_ruby_time((last_mod_date << 16) | last_mod_time)
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
