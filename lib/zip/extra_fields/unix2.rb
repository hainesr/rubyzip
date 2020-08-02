require_relative 'extension'

module Zip
  module ExtraFields
    # Info-ZIP Extra for UNIX uid/gid.
    class Unix2 < Extension
      EXTRA_FIELD_ID = 'Ux'
      PROVIDES = :ownership
      register_extra_field_type

      attr_accessor :uid, :gid

      def initialize(data = nil)
        @uid = 0
        @gid = 0
        merge(data) unless data.nil?
      end

      def merge(data)
        return if data.empty?

        uid, gid = data.unpack('vv')
        @uid = uid
        @gid = gid
      end

      def ==(other)
        @uid == other.uid && @gid == other.gid
      end

      def to_local_bin
        [@uid, @gid].pack('vv')
      end

      def local_size
        4
      end

      def c_dir_size
        0
      end
    end
  end
end
