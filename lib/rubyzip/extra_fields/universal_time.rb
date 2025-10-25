# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'extra_field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # An extra field that stores additional file and directory timestamp data
    # for an Entry. Each Entry can include up to three timestamps - modify,
    # access, and create. The timestamps are stored as 32 bit signed integers
    # representing seconds since the UNIX epoch (Jan 1st, 1970, UTC).
    # This field improves on zip's default timestamp granularity, since it
    # allows one to store additional timestamps, and, in addition, the
    # timestamps are stored using per-second granularity (zip's default
    # behavior can only store timestamps to the nearest even second).
    class UniversalTime < ExtraField
      EXTRA_FIELD_ID = 'UT'.b

      ATIME_MASK = 0b010
      CTIME_MASK = 0b100
      MTIME_MASK = 0b001

      attr_reader :atime, :ctime, :mtime

      private

      def merge(data)
        flags = data.unpack1('C')
        i = -3 # Start at -3 so we can increment i below first.

        @mtime, @atime, @ctime =
          [MTIME_MASK, ATIME_MASK, CTIME_MASK].map do |mask|
            next if flags.nobits?(mask)

            i += 4
            Time.at(data[i, 4].unpack1('l<'), in: 'UTC')
          end
      end
    end
  end
end
