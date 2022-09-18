# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../utilities'
require_relative 'field'

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
    class UniversalTime < Field
      # The ID of this extra field (UT).
      EXTRA_FIELD_ID = 'UT'.b

      ATIME_MASK = 0b010 # :nodoc:
      CTIME_MASK = 0b100 # :nodoc:
      MTIME_MASK = 0b001 # :nodoc:

      # The last access time of the entry.
      attr_reader :atime

      # The creation time of the entry.
      attr_reader :ctime

      # The last modification time of the entry.
      attr_reader :mtime

      private

      def merge(data)
        flags = Utilities.read1(data)
        i = -3 # Start at -3 so we can increment i below first.

        @mtime, @atime, @ctime =
          [MTIME_MASK, ATIME_MASK, CTIME_MASK].map do |mask|
            next if (flags & mask).zero?

            i += 4
            # Change the below to 'UTC' when TruffleRuby supports it?
            Time.at(Utilities.read4s(data, i), in: '+00:00')
          end
      end
    end
  end
end
