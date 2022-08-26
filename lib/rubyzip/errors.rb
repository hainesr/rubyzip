# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip
  # The general error raised by Rubyzip and the superclass of other
  # Rubyzip errors.
  class Error < StandardError; end

  # This error is raised if there is a mismatch between CRC-32 checksums
  # when decompressing an entry.
  class CRC32Error < Error
    def initialize(expected, actual)
      super()

      @expected = expected
      @actual = actual
    end

    def message
      "Invalid CRC32 checksum when decompressed - expected 0x#{@expected}; got 0x#{@actual}."
    end
  end
end
