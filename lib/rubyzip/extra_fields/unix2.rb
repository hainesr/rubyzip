# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../utilities'
require_relative 'field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # Info-ZIP UNIX Extra Field (type 2).
    #
    # This extra field holds 16bit UIDs and GIDs.
    class Unix2 < Field
      # The ID of this extra field (Ux).
      EXTRA_FIELD_ID = 'Ux'.b

      # The group ID of the entry.
      attr_reader :gid

      # The user ID of the entry.
      attr_reader :uid

      private

      def merge(data)
        @uid = Utilities.read2(data)
        @gid = Utilities.read2(data, 2)
      end
    end
  end
end
