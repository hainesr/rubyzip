# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../utilities'
require_relative 'field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # Info-ZIP New Unix Extra Field.
    class Unix3 < Field
      EXTRA_FIELD_ID = 'ux'.b

      attr_reader :gid, :uid, :version

      private

      def merge(data)
        @version = Utilities.read8(data)

        uid_size = Utilities.read8(data, 1)
        @uid = Utilities.read(data, uid_size * 8, 2)

        gid_size = Utilities.read8(data, uid_size + 2)
        @gid = Utilities.read(data, gid_size * 8, uid_size + 3)
      end
    end
  end
end
