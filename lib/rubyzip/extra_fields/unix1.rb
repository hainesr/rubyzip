# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'extra_field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # Info-ZIP UNIX Extra Field (type 1).
    #
    # This extra field has been replaced by extended-timestamp extra block
    # (UT) and the Unix type 3 extra block (ux). It is considered obsolete.
    class Unix1 < ExtraField
      # The ID of this extra field (UX).
      EXTRA_FIELD_ID = 'UX'.b

      # The last access time of the entry.
      attr_reader :atime

      # The last modification time of the entry.
      attr_reader :mtime

      # The group ID of the entry, if present.
      attr_reader :gid

      # The user ID of the entry, if present.
      attr_reader :uid

      private

      def merge(data)
        @atime = Time.at(data.unpack1('l<'), in: 'UTC')
        @mtime = Time.at(data[4, 4].unpack1('l<'), in: 'UTC')

        # Do we have UID and GID?
        return unless data.bytesize > 8

        @uid = data[8, 2].unpack1('v')
        @gid = data[10, 2].unpack1('v')
      end
    end
  end
end
