# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'codecs'
require_relative 'entry'
require_relative 'utilities'

##
module Rubyzip
  # InputStream provides a simple streaming interface for reading zip entries
  # from a zip file.
  class InputStream
    def initialize(io)
      @io = io
      @current_entry = nil
    end

    def close_entry
      # Just read to the end of the current entry.
      read

      nil
    end

    def next_entry
      close_entry unless @current_entry.nil?

      begin
        name, header, = Utilities.read_local_header(@io)
      rescue Error
        return nil
      end

      @current_entry = Entry.new(name, header)
      decompressor_class = Codecs.decompressor_for_entry(@current_entry)
      @decompressor = decompressor_class.new(@io, @current_entry)

      @current_entry
    end

    def read(len = nil)
      return (len.nil? || len.zero? ? '' : nil) if @current_entry.nil?

      buf = @decompressor.read(len)
      if buf.nil? || @decompressor.eof?
        @current_entry = nil
        @decompressor.validate_crc32!
      end

      buf
    end
  end
end
