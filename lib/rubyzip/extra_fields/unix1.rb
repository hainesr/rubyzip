# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../utilities'
require_relative 'field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # Info-ZIP UNIX Extra Field (type 1).
    #
    # This extra field has been replaced by extended-timestamp extra block
    # (UT) and the Unix type 3 extra block (ux). It is considered obsolete.
    class Unix1 < Field
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
        # Change the below to 'UTC' when TruffleRuby supports it?
        @atime = Time.at(Utilities.read4s(data), in: '+00:00')
        @mtime = Time.at(Utilities.read4s(data, 4), in: '+00:00')

        # Do we have UID and GID?
        return unless data.bytesize > 8

        @uid = Utilities.read2(data, 8)
        @gid = Utilities.read2(data, 10)
      end
    end
  end
end
