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
    NAME_TOO_LONG_MESSAGE = # :nodoc:
      'Entry name cannot be longer than 65,535 characters or larger than 65,535 bytes.'

    # The name of this Entry.
    attr_reader :name

    # :call-seq:
    #   new(name) -> Entry
    #
    # Create a new Entry with the given name.
    def initialize(name, header: nil, extra_field_data: nil)
      raise ArgumentError, NAME_TOO_LONG_MESSAGE if name.bytesize > 0xFFFF

      @header_data = header
      @extra_fields = ExtraFields::Set.new(extra_field_data)
      @name = normalize_string_encoding(name)
    end

    # :call-seq:
    #   compressed_size -> Integer
    #
    # The compressed size of the data held by this Entry.
    def compressed_size
      return if @header_data.nil?

      size = Utilities.read4(@header_data, LOC_OFF_COMP_SIZE)
      zip64? && size == ZIP64_MASK_4B ? @extra_fields['Zip64'].compressed_size : size
    end

    # :call-seq:
    #  compression_method -> Integer
    #
    # The compression method used by this Entry. This is most commonly `8`
    # (Deflated), or `0` (Stored).
    def compression_method
      Utilities.read2(@header_data, LOC_OFF_COMP_METHOD) unless @header_data.nil?
    end

    # :call-seq:
    #   crc32 -> Integer
    #
    # The CRC-32 checksum of the data in this Entry before it was compressed.
    # This is used to verify that the uncompression processes has worked
    # correctly.
    def crc32
      Utilities.read4(@header_data, LOC_OFF_CRC32) unless @header_data.nil?
    end

    # :call-seq:
    #   dierectory? -> true or false
    #
    # Is this Entry a directory, as opposed to a file? Directories cannot
    # hold any data.
    def directory?
      @name.end_with?('/')
    end

    # :call-seq:
    #   encrypted? -> true or false
    #
    # Is the data within this Entry encrypted?
    def encrypted?
      test_flag(GP_FLAGS_ENCRYPTED) unless @header_data.nil?
    end

    # :call-seq:
    #   mtime -> Time
    #
    # Returns the last modified time of the Entry. If the Entry was copied
    # into the Zip archive from a file or directory on disk, then this time
    # will be the last modified time of that file or directory. If the Entry
    # was streamed, then it will be the time that the Entry was created in
    # the Zip archive.
    def mtime
      return if @header_data.nil?

      # If there is an extra field that provides mtime, use it if it's set.
      time = @extra_fields.delegate(:mtime) if @extra_fields.respond_to?(:mtime)
      time || Utilities.dos_to_ruby_time(Utilities.read4(@header_data, LOC_OFF_MOD_TIME))
    end

    # :call-seq:
    #   streamed? -> true or false
    #
    # Was this Entry streamed when it was written into the Zip archive?
    # Streamed entries can often not be streamed back out directly due to
    # certain data not being available in the Entry's local header.
    def streamed?
      test_flag(GP_FLAGS_STREAMED) unless @header_data.nil?
    end

    # :call-seq:
    #   uncompressed_size -> Integer
    #
    # The original (uncompressed) size of the data held by this Entry.
    def uncompressed_size
      return if @header_data.nil?

      size = Utilities.read4(@header_data, LOC_OFF_UNCOMP_SIZE)
      zip64? && size == ZIP64_MASK_4B ? @extra_fields['Zip64'].uncompressed_size : size
    end

    # :call-seq:
    #   utf8? -> true or false
    #
    # Is the Entry name or comment stored in UTF8 format? Most modern Zip
    # tooling stores names and comments in UTF8 format without setting this
    # flag, so this method can not always answer reliably.
    def utf8?
      test_flag(GP_FLAGS_UTF8) unless @header_data.nil?
    end

    # :call-seq:
    #   zip64? -> true or false
    #
    # Does this Entry use the Zip64 extensions? Entries with data sizes
    # (compressed and uncompressed) under 4GB do not need the 64bit
    # extensions, but may use them.
    def zip64?
      !@extra_fields['Zip64'].nil?
    end

    # :call-seq:
    #   version_needed_to_extract -> Integer
    #
    # The version of the Zip standard that the extracting tools needs to
    # support to be able to extract this Entry.
    def version_needed_to_extract
      return 10 if @header_data.nil?

      Utilities.read2(@header_data, LOC_OFF_VER_EXTRACT)
    end

    # :nodoc:
    def method_missing(symbol, *args)
      return super unless respond_to?(symbol)

      @extra_fields.delegate(symbol, *args)
    end

    # :nodoc:
    def respond_to_missing?(symbol, include_all)
      @extra_fields.respond_to?(symbol, include_all)
    end

    # :nodoc:
    def update_streaming_data(new_data)
      @header_data = @header_data.slice(0...LOC_OFF_CRC32) + new_data
    end

    private

    def normalize_string_encoding(string)
      return string if string.frozen?

      if utf8?
        string.force_encoding('UTF-8')
      else
        string.force_encoding(Rubyzip.name_and_comment_encoding)
      end
    end

    def test_flag(mask)
      (Utilities.read2(@header_data, LOC_OFF_GP_FLAGS) & mask) == mask
    end
  end
end
