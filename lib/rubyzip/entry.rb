# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'constants'
require_relative 'utilities'
require_relative 'extra_fields/set'

##
module Rubyzip
  # Entry represents an entry in a zip file.
  class Entry
    NAME_TOO_LONG_MESSAGE =
      'Entry name cannot be longer than 65,535 characters or larger than 65,535 bytes.'

    attr_reader :name

    def initialize(name, header: nil, extra_field_data: nil)
      raise ArgumentError, NAME_TOO_LONG_MESSAGE if name.bytesize > 0xFFFF

      @name = name
      @header_data = header
      @extra_fields = ExtraFields::Set.new(extra_field_data)
    end

    def compressed_size
      return if @header_data.nil?

      size = Utilities.read32(@header_data, LOC_OFF_COMP_SIZE)
      zip64? && size == ZIP64_MASK_4B ? @extra_fields['Zip64'].compressed_size : size
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

      # If there is an extra field that provides mtime, use it if it's set.
      time = @extra_fields.delegate(:mtime) if @extra_fields.respond_to?(:mtime)
      time || Utilities.dos_to_ruby_time(Utilities.read32(@header_data, LOC_OFF_MOD_TIME))
    end

    def streamed?
      test_flag(GP_FLAGS_STREAMED) unless @header_data.nil?
    end

    def uncompressed_size
      return if @header_data.nil?

      size = Utilities.read32(@header_data, LOC_OFF_UNCOMP_SIZE)
      zip64? && size == ZIP64_MASK_4B ? @extra_fields['Zip64'].uncompressed_size : size
    end

    def utf8?
      test_flag(GP_FLAGS_UTF8) unless @header_data.nil?
    end

    def zip64?
      !@extra_fields['Zip64'].nil?
    end

    def version_needed_to_extract
      return 10 if @header_data.nil?

      Utilities.read16(@header_data, LOC_OFF_VER_EXTRACT)
    end

    def method_missing(symbol, *args)
      return super unless respond_to?(symbol)

      @extra_fields.delegate(symbol, *args)
    end

    def respond_to_missing?(symbol, include_all)
      @extra_fields.respond_to?(symbol, include_all)
    end

    private

    def test_flag(mask)
      (Utilities.read16(@header_data, LOC_OFF_GP_FLAGS) & mask) == mask
    end
  end
end
