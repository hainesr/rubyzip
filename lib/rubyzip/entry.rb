# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip
  # Entry represents an entry in a zip file.
  class Entry
    attr_reader :compression_method, :compressed_size, :crc32, :name, :uncompressed_size

    def initialize(name, header = nil)
      @name = name

      return unless header

      _sig, _version_to_extract, _fs_type, @gp_flags, @compression_method,
      _last_mod_time, _last_mod_date, @crc32, @compressed_size, @uncompressed_size,
      _name_len, _extra_len = header.unpack(LOC_PACK)
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
  end
end
