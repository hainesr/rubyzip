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
    NAME_TOO_LONG_MESSAGE = # :nodoc:
      "Entry name cannot be longer than #{LIMIT_ENTRY_NAME_SIZE} characters " \
      "or larger than #{LIMIT_ENTRY_NAME_SIZE} bytes.".freeze

    # The compression method used to store the payload for this entry.
    attr_reader :compression_method

    # The CRC32 checksum of this entry's payload.
    attr_reader :crc32

    # The name of the entry.
    attr_reader :name

    # :call-seq:
    #   new(name) -> Entry
    #
    # Create a new Entry with the given name.
    def initialize(name, header = nil, extra_field_data = nil)
      raise ArgumentError, NAME_TOO_LONG_MESSAGE if name.bytesize > LIMIT_ENTRY_NAME_SIZE

      @name = normalize_string_encoding(name)
      @extra_fields = ExtraFields::Set.new(extra_field_data)

      return unless header

      _sig, @version_needed_to_extract, _fs_type, @gp_flags, @compression_method,
      last_mod_time, last_mod_date, @crc32, @compressed_size, @uncompressed_size,
      _name_len, _extra_len = header.unpack(LOC_PACK)

      @mtime = Utilities.dos_to_ruby_time((last_mod_date << 16) | last_mod_time)
    end

    # :call-seq:
    #   compressed_size -> Integer
    #
    # The compressed size of the data held by this Entry.
    def compressed_size
      if zip64? && @compressed_size == LIMIT_ENTRY_COMPRESSED_SIZE
        @extra_fields['Zip64'].compressed_size
      else
        @compressed_size
      end
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
      @gp_flags & GP_FLAGS_ENCRYPTED == GP_FLAGS_ENCRYPTED
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
      # If there is an extra field that provides mtime, use it if it's set.
      time = @extra_fields.delegate(:mtime) if @extra_fields.respond_to?(:mtime)
      time || @mtime
    end

    # :call-seq:
    #   streamed? -> true or false
    #
    # Was this Entry streamed when it was written into the Zip archive?
    # Streamed entries can often not be streamed back out directly due to
    # certain data not being available in the Entry's local header.
    def streamed?
      @gp_flags & GP_FLAGS_STREAMED == GP_FLAGS_STREAMED
    end

    # :call-seq:
    #   uncompressed_size -> Integer
    #
    # The original (uncompressed) size of the data held by this Entry.
    def uncompressed_size
      if zip64? && @uncompressed_size == LIMIT_ENTRY_UNCOMPRESSED_SIZE
        @extra_fields['Zip64'].uncompressed_size
      else
        @uncompressed_size
      end
    end

    # :call-seq:
    #   utf8? -> true or false
    #
    # Is the Entry name or comment stored in UTF8 format? Most modern Zip
    # tooling stores names and comments in UTF8 format without setting this
    # flag, so this method can not always answer reliably.
    def utf8?
      @gp_flags & GP_FLAGS_UTF8 == GP_FLAGS_UTF8
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
      @version_needed_to_extract || 10
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
      @crc32, @compressed_size, @uncompressed_size = new_data
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
  end
end
