# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../utilities'
require_relative 'field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # Zip64 extra field.
    class Zip64 < Field
      EXTRA_FIELD_ID = "\x01\x00".b

      attr_reader :compressed_size, :uncompressed_size

      private

      # We're currently only reading local headers, so we know we will have
      # compressed and uncompressed size, and those are all we need here.
      def merge(data)
        @uncompressed_size = Utilities.read8(data)
        @compressed_size = Utilities.read8(data, 8)
      end
    end
  end
end
