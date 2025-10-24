# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../utilities'
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
      EXTRA_FIELD_ID = 'UT'

      ATIME_MASK = 0b010
      CTIME_MASK = 0b100
      MTIME_MASK = 0b001

      def initialize(data)
        @index = {}
        super
      end

      def atime
        @atime ||= time(:atime)
      end

      def ctime
        @ctime ||= time(:ctime)
      end

      def mtime
        @mtime ||= time(:mtime)
      end

      private

      def merge
        i = 0
        if flag?(MTIME_MASK)
          @index[:mtime] = i
          i += 1
        end

        if flag?(ATIME_MASK)
          @index[:atime] = i
          i += 1
        end

        @index[:ctime] = i if flag?(CTIME_MASK)
      end

      def flag?(mask)
        @data.unpack1('C').allbits?(mask)
      end

      def time(type)
        return if @index[type].nil?

        Time.at(@data[1 + (@index[type] * 4), 4].unpack1('l<'))
      end
    end
  end
end
