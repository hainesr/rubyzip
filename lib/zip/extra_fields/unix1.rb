require_relative 'extension'

module Zip
  module ExtraFields
    # Old Info-ZIP Extra for UNIX uid/gid and file timestamps.
    class Unix1 < Extension
      EXTRA_FIELD_ID = 'UX'
      register_extra_field_type

      attr_accessor :uid, :gid, :atime, :mtime

      def initialize(data = nil)
        @uid = 0
        @gid = 0
        @atime = nil
        @mtime = nil
        merge(data) unless data.nil?
      end

      def merge(data)
        return if data.empty?

        atime, mtime, uid, gid = data.unpack('l<l<vv')
        @atime ||= ::Zip::DOSTime.at(atime)
        @mtime ||= ::Zip::DOSTime.at(mtime)
        @uid = uid unless uid.nil?
        @gid = gid unless gid.nil?
      end

      def ==(other)
        @uid == other.uid && @gid == other.gid &&
          @atime == other.atime && @mtime == other.mtime
      end

      def to_local_bin
        [@atime.to_i, @mtime.to_i, @uid, @gid].pack('l<l<vv')
      end

      def to_c_dir_bin
        [@atime.to_i, @mtime.to_i].pack('l<l<')
      end

      def local_size
        12
      end

      def c_dir_size
        8
      end
    end
  end
end
