# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'extra_field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # Info-ZIP UNIX Extra Field (type 2).
    #
    # This extra field holds 16bit UIDs and GIDs.
    class Unix2 < ExtraField
      EXTRA_FIELD_ID = 'Ux'

      attr_reader :gid, :uid

      private

      def merge(data)
        @uid = data.unpack1('v')
        @gid = data[2, 2].unpack1('v')
      end
    end
  end
end
