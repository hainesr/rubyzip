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
  # from a Zip archive in sequence.
  #
  # This class does not read any information from the Zip Central Directory.
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
    # :call-seq:
    #   new(io) -> InputStream
    #   new(file) -> InputStream
    #
    # Create a new Zip archive InputStream from the file or IO-like object
    # provided.
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

    # :call-seq:
    #   open(io) -> InputStream
    #   open(file) -> InputStream
    #   open(io) { |zis| ... }
    #   open(file) { |zis| ... }
    #
    # If no block is provided, then `open` is equivalent to `new`. If a block
    # is provided then the InputStream is yielded to the block and closed
    # afterwards.
    def self.open(io_or_file)
      zis = new(io_or_file)
      return zis unless block_given?

      begin
        yield zis
      ensure
        zis.close
      end
    end

    # :call-seq:
    #   close
    #
    # Close this InputStream. This method will not close the underlying
    # IO-like object unless it was created by `new` or `open` when creating
    # this InputStream.
    def close
      @io.close if @io_from_file
    end

    # :call-seq:
    #   close_entry
    #
    # Close the current Entry for reading and position the InputStream
    # ready to read the next Entry.
    def close_entry
      return if @current_entry.nil?

      # Just read to the end of the current entry.
      read

      @current_entry = nil
    end

    # :call-seq:
    #   next_entry -> Entry
    #   next_entry(password: password)
    #
    # Open the next Entry in the InputStream for reading and return it. The
    # data contained by the Entry can then be subsequently read by
    # `InputStream#read`. Provide a password if the data within the Entry
    # is encrypted.
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

    # :call-seq:
    #   read -> String
    #   read(length) -> String
    #
    # Read from this InputStream, decrypting and decompressing data on the
    # fly, if needs be. Upto `length` bytes are returned, or fewer if the
    # end of the stream is reached first. If `length` is not provided then
    # the whole, or rest of, the stream is returned.
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
