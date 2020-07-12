require_relative 'abstract'

module Zip
  module ExtraFields
    # PKWARE NTFS Extra Field (0x000a)
    # Only Tag 0x0001 is supported
    class NTFS < Abstract
      EXTRA_FIELD_ID = [0x000A].pack('v')
      register_extra_field_type

      WINDOWS_TICK = 10_000_000.0
      SEC_TO_UNIX_EPOCH = 11_644_473_600

      attr_accessor :atime, :ctime, :mtime

      def initialize(data = nil)
        @ctime = nil
        @mtime = nil
        @atime = nil

        merge(data) unless data.nil?
      end

      def merge(data)
        return if data.empty?

        # Parse tag data, after throwing away unused reserved field (4 bytes).
        tags = parse_tags(data[4..-1])

        tag1 = tags[1]
        return unless tag1

        ntfs_mtime, ntfs_atime, ntfs_ctime = tag1.unpack('Q<Q<Q<')
        @mtime ||= from_ntfs_time(ntfs_mtime) if ntfs_mtime
        @atime ||= from_ntfs_time(ntfs_atime) if ntfs_atime
        @ctime ||= from_ntfs_time(ntfs_ctime) if ntfs_ctime
      end

      def ==(other)
        @mtime == other.mtime &&
          @atime == other.atime &&
          @ctime == other.ctime
      end

      # Info-ZIP note states this extra field is only stored at local header.
      def to_local_bin
        to_c_dir_bin
      end

      # But 7-zip for Windows only stores at central dir.
      def to_c_dir_bin
        # reserved 0 and tag 1
        s = [0, 1].pack('Vv')

        tag1 = ''
        if @mtime
          tag1 << [to_ntfs_time(@mtime)].pack('Q<')
          if @atime
            tag1 << [to_ntfs_time(@atime)].pack('Q<')
            tag1 << [to_ntfs_time(@ctime)].pack('Q<') if @ctime
          end
        end
        s << [tag1.bytesize].pack('v') << tag1
        s
      end

      private

      def parse_tags(data)
        return {} if data.nil?

        tags = {}
        i = 0
        while i < data.bytesize
          tag, size = data[i, 4].unpack('vv')
          i += 4
          break unless tag && size

          value = data[i, size]
          i += size
          tags[tag] = value
        end

        tags
      end

      def from_ntfs_time(ntfs_time)
        ::Zip::DOSTime.at(ntfs_time / WINDOWS_TICK - SEC_TO_UNIX_EPOCH)
      end

      def to_ntfs_time(time)
        ((time.to_f + SEC_TO_UNIX_EPOCH) * WINDOWS_TICK).to_i
      end
    end
  end
end
