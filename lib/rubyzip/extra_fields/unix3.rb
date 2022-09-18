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
        @version = Utilities.read1(data)

        uid_size = Utilities.read1(data, 1)
        @uid = Utilities.read(data, uid_size, 2)

        gid_size = Utilities.read1(data, uid_size + 2)
        @gid = Utilities.read(data, gid_size, uid_size + 3)
      end
    end
  end
end
