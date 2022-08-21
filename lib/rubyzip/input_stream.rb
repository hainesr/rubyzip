# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

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
      name, = Utilities.read_local_header(@io)

      Entry.new(name)
    end
  end
end
