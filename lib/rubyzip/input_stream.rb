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
  # from a ZIP archive in sequence.
  #
  # This class does not read any information from the ZIP Central Directory.
  #
  # ## Read from a file
  #
  # ```
  # Rubyzip::InputStream.open('my_zip.zip') do |zis|
  #   while (entry = zis.next_entry)
  #     puts "Contents of #{entry.name}: '#{zis.read}'"
  #   end
  # end
  # ```
  #
  # ## Read from a stream
  #
  # Stream can be any IO-like class, such as StringIO.
  #
  # ```
  # ::File.open('my_zip.zip', 'rb') do |io|
  #   Rubyzip::InputStream.open(io) do |zis|
  #     while (entry = zis.next_entry)
  #       puts "Contents of #{entry.name}: '#{zis.read}'"
  #     end
  #   end
  # end
  # ```
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

      @current_entry = Entry.new(name, header: header, extra_field_data: extras)
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
