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
      EXTRA_FIELD_ID = 'UT'

      ATIME_MASK = 0b010
      CTIME_MASK = 0b100
      MTIME_MASK = 0b001

      def initialize(data)
        @index = {}
        super
      end

      def atime
        time(:atime)
      end

      def ctime
        time(:ctime)
      end

      def mtime
        time(:mtime)
      end

      private

      def merge
        i = 0
        if test_flag(MTIME_MASK)
          @index[:mtime] = i
          i += 1
        end

        if test_flag(ATIME_MASK)
          @index[:atime] = i
          i += 1
        end

        @index[:ctime] = i if test_flag(CTIME_MASK)
      end

      def test_flag(mask)
        (Utilities.read8(@data) & mask) == mask
      end

      def time(type)
        return if @index[type].nil?

        Time.at(Utilities.read32s(@data, 1 + (@index[type] * 4)))
      end
    end
  end
end
