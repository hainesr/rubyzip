# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
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
      'Invalid CRC32 checksum when decompressed - ' \
        "expected 0x#{@expected.to_s(16)}; got 0x#{@actual.to_s(16)}."
    end
  end

  # This error is raised if the size of an entry gets too big as it is being
  # extracted.
  class EntrySizeError < Error
    def initialize(entry)
      super()
      @entry = entry
    end

    def message
      "Entry '#{@entry.name}' should be #{@entry.uncompressed_size}B, " \
        'but is larger when extracted.'
    end
  end
end
