# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'constants'
require_relative 'utilities'
require_relative 'entry'

##
module Rubyzip
  class CentralDirectory # :nodoc:
    attr_reader :comment, :size

    def initialize(io)
      @entries = {}

      @size, @cdir_offset, @comment = Utilities.read_end_central_directory_records(io)
    end
  end
end
