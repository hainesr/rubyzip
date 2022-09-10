# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
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
    def initialize(io)
      @io = io
      @current_entry = nil
    end

    def self.open(io)
      zis = new(io)
      return zis unless block_given?

      yield zis
    end

    def close_entry
      # Just read to the end of the current entry.
      read

      nil
    end

    def next_entry(password: '')
      close_entry unless @current_entry.nil?

      begin
        name, header, = Utilities.read_local_header(@io)
      rescue Error
        return nil
      end

      @current_entry = Entry.new(name, header: header)
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
