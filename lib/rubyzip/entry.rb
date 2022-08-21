# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip
  # Entry represents an entry in a zip file.
  class Entry
    attr_reader :name

    def initialize(name, header: nil)
      @name = name
      @header_data = header
    end

    def compression_method
      Utilities.read16(@header_data, LOC_OFF_COMP_METHOD) unless @header_data.nil?
    end
  end
end
