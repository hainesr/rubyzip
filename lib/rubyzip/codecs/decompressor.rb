# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../constants'

##
module Rubyzip
  module Codecs
    # The base class for decompressors.
    class Decompressor
      def initialize(io, entry)
        @io = io
        @entry = entry
      end
    end
  end
end
