# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'extra_field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # Zip64 extra field.
    class Zip64 < ExtraField
      EXTRA_FIELD_ID = "\x01\x00".b

      attr_reader :compressed_size, :uncompressed_size

      private

      # We're currently only reading local headers, so we know we will have
      # compressed and uncompressed size, and those are all we need here.
      def merge(data)
        @uncompressed_size = data.unpack1('Q<')
        @compressed_size = data[8, 8].unpack1('Q<')
      end
    end
  end
end
