# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
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

    def next_entry
      begin
        name, header, = Utilities.read_local_header(@io)
      rescue Error
        return nil
      end

      @current_entry = Entry.new(name, header: header)
      decompressor_class = Codecs.decompressor_for_entry(@current_entry)
      @decompressor = decompressor_class.new(@io, @current_entry)

      @current_entry
    end

    def read(len = nil)
      return if @current_entry.nil?

      buf = @decompressor.read(len)
      @current_entry = nil if buf.nil?

      buf
    end
  end
end
