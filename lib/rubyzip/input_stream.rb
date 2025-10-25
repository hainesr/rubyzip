# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'entry'
require_relative 'entry_input_stream'
require_relative 'utilities'

##
module Rubyzip
  # InputStream provides a simple streaming interface for reading zip entries
  # from a zip file.
  class InputStream
    def initialize(io_or_file)
      if io_or_file.respond_to?(:read)
        @io = io_or_file
        @io_from_file = false
      else
        @io = ::File.open(io_or_file, 'rb')
        @io_from_file = true
      end

      @current_entry = nil
    end

    def self.open(io_or_file)
      zis = new(io_or_file)
      return zis unless block_given?

      begin
        yield zis
      ensure
        zis.close
      end
    end

    def close
      @io.close if @io_from_file
    end

    def close_entry
      # Just read to the end of the current entry.
      read

      nil
    end

    def next_entry(password: '')
      close_entry unless @current_entry.nil?

      begin
        name, header, extras = Utilities.read_local_header(@io)
      rescue Error
        return nil
      end

      @current_entry = Entry.new(name, header, extras)
      @entry_input_stream = EntryInputStream.new(@io, @current_entry, password)

      @current_entry
    end

    def read(len = nil)
      return (len.nil? || len.zero? ? '' : nil) if @current_entry.nil?

      buf = @entry_input_stream.read(len)
      if buf.nil? || @entry_input_stream.eof?
        @current_entry = nil
        @entry_input_stream.validate_crc32!
      end

      buf
    end
  end
end
