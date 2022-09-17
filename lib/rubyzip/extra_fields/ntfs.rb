# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../utilities'
require_relative 'field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # An extra field that stores file and directory timestamp data (in Win32
    # format) for an Entry.
    class NTFS < Field
      EXTRA_FIELD_ID = "\n\x00"

      WINDOWS_TICK = 10_000_000.0
      SEC_TO_UNIX_EPOCH = 11_644_473_600

      attr_accessor :atime, :ctime, :mtime

      private

      # [Info-ZIP note: In the current implementations, this field has a fixed
      # total data size of 32 bytes and is only stored as local extra field.]
      #
      # Given the above we can afford to take a few shortcuts here...
      def merge(data)
        # Tag1 data starts at byte 4, and the time data starts at byte 8.
        @mtime = from_ntfs_time(Utilities.read64(data, 8))
        @atime = from_ntfs_time(Utilities.read64(data, 16))
        @ctime = from_ntfs_time(Utilities.read64(data, 24))
      end

      def from_ntfs_time(ntfs_time)
        Time.at((ntfs_time / WINDOWS_TICK) - SEC_TO_UNIX_EPOCH, in: '+00:00')
      end
    end
  end
end
