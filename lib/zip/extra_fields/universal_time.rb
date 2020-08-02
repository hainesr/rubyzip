require_relative 'extension'

module Zip
  module ExtraFields
    # Info-ZIP Additional timestamp field
    class UniversalTime < Extension
      EXTRA_FIELD_ID = 'UT'
      PROVIDES = :timestamp
      register_extra_field_type

      ATIME_MASK = 0b010
      CTIME_MASK = 0b100
      MTIME_MASK = 0b001

      attr_accessor :atime, :ctime, :mtime

      def initialize(data = nil)
        @ctime = nil
        @mtime = nil
        @atime = nil

        merge(data) unless data.nil?
      end

      def merge(data)
        return if data.empty?

        flag, *times = data.unpack('Cl<l<l<')

        # Parse the timestamps, in order, based on which flags are set.
        return if times[0].nil?

        @mtime ||= ::Zip::DOSTime.at(times.shift) unless flag & MTIME_MASK == 0
        return if times[0].nil?

        @atime ||= ::Zip::DOSTime.at(times.shift) unless flag & ATIME_MASK == 0
        return if times[0].nil?

        @ctime ||= ::Zip::DOSTime.at(times.shift) unless flag & CTIME_MASK == 0
      end

      def ==(other)
        @mtime == other.mtime &&
          @atime == other.atime &&
          @ctime == other.ctime
      end

      def to_local_bin
        s = to_c_dir_bin
        s << [@atime.to_i].pack('l<') unless @atime.nil?
        s << [@ctime.to_i].pack('l<') unless @ctime.nil?
        s
      end

      def to_c_dir_bin
        s = [flags].pack('C')
        s << [@mtime.to_i].pack('l<') unless @mtime.nil?
        s
      end

      def local_size
        1 +
          (@mtime.nil? ? 0 : 4) +
          (@atime.nil? ? 0 : 4) +
          (@ctime.nil? ? 0 : 4)
      end

      def c_dir_size
        1 + (@mtime.nil? ? 0 : 4)
      end

      private

      def flags
        (@mtime.nil? ? 0 : MTIME_MASK) +
        (@atime.nil? ? 0 : ATIME_MASK) +
        (@ctime.nil? ? 0 : CTIME_MASK)
      end
    end
  end
end
