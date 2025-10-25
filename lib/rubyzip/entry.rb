# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'constants'
require_relative 'extra_fields/set'
require_relative 'utilities'

##
module Rubyzip
  # Entry represents an entry in a zip file.
  class Entry
    NAME_TOO_LONG_MESSAGE =
      "Entry name cannot be longer than #{LIMIT_ENTRY_NAME_SIZE} characters " \
      "or larger than #{LIMIT_ENTRY_NAME_SIZE} bytes.".freeze

    attr_reader :compression_method, :crc32, :name

    def initialize(name, header = nil, extra_field_data = nil)
      raise ArgumentError, NAME_TOO_LONG_MESSAGE if name.bytesize > LIMIT_ENTRY_NAME_SIZE

      @name = name
      @extra_fields = ExtraFields::Set.new(extra_field_data)

      return unless header

      _sig, @version_needed_to_extract, _fs_type, @gp_flags, @compression_method,
      last_mod_time, last_mod_date, @crc32, @compressed_size, @uncompressed_size,
      _name_len, _extra_len = header.unpack(LOC_PACK)

      @mtime = Utilities.dos_to_ruby_time((last_mod_date << 16) | last_mod_time)
    end

    def compressed_size
      if zip64? && @compressed_size == LIMIT_ENTRY_COMPRESSED_SIZE
        @extra_fields['Zip64'].compressed_size
      else
        @compressed_size
      end
    end

    def directory?
      @name.end_with?('/')
    end

    def encrypted?
      @gp_flags & GP_FLAGS_ENCRYPTED == GP_FLAGS_ENCRYPTED
    end

    def mtime
      # If there is an extra field that provides mtime, use it if it's set.
      time = @extra_fields.delegate(:mtime) if @extra_fields.respond_to?(:mtime)
      time || @mtime
    end

    def streamed?
      @gp_flags & GP_FLAGS_STREAMED == GP_FLAGS_STREAMED
    end

    def uncompressed_size
      if zip64? && @uncompressed_size == LIMIT_ENTRY_UNCOMPRESSED_SIZE
        @extra_fields['Zip64'].uncompressed_size
      else
        @uncompressed_size
      end
    end

    def utf8?
      @gp_flags & GP_FLAGS_UTF8 == GP_FLAGS_UTF8
    end

    def zip64?
      !@extra_fields['Zip64'].nil?
    end

    def version_needed_to_extract
      @version_needed_to_extract || 10
    end

    def method_missing(symbol, *args)
      return super unless respond_to?(symbol)

      @extra_fields.delegate(symbol, *args)
    end

    def respond_to_missing?(symbol, include_all)
      @extra_fields.respond_to?(symbol, include_all)
    end
  end
end
