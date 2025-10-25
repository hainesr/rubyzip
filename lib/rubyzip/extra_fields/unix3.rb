# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../utilities'
require_relative 'extra_field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # Info-ZIP New Unix Extra Field.
    class Unix3 < ExtraField
      # The ID of this extra field (ux).
      EXTRA_FIELD_ID = 'ux'.b

      # The group ID of the entry.
      attr_reader :gid

      # The user ID of the entry.
      attr_reader :uid

      # The version of this extra field type (at present, always 1).
      attr_reader :version

      private

      def merge(data)
        @version = data.unpack1('C')                                        # offset 0
        uid_size = data[1].unpack1('C')                                     # offset 1
        @uid = data[2, uid_size].unpack1(Utilities::UNPACK_BYTES[uid_size]) # offset 2
        gid_size = data[2 + uid_size].unpack1('C')                          # offset 2 + uid_size
        @gid = data[3 + uid_size, gid_size].unpack1(Utilities::UNPACK_BYTES[gid_size])
      end
    end
  end
end
