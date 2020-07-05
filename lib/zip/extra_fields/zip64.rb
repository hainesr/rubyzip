require_relative 'abstract'

module Zip
  module ExtraFields
    # A placeholder to reserve space for a Zip64 extra information record,
    # for the local file header only, that we won't know if we'll need
    # until after we write the file data.
    class Zip64Placeholder < Abstract
      # This ID is used by other libraries such as .NET's Ionic.zip.
      EXTRA_FIELD_ID = [0x9999].pack('v')

      def initialize(_data = nil); end

      def to_local_bin
        "\x00" * 16
      end

      def local_size
        16
      end

      def ==(_comp)
        true
      end
    end

    # Info-ZIP Extra for Zip64 size.
    class Zip64 < Abstract
      EXTRA_FIELD_ID = [0x0001].pack('v')
      ExtraFieldSet.register_zip64_extra_field_types(self, Zip64Placeholder)

      attr_accessor :compressed_size,
                    :disk_start_number,
                    :original_size,
                    :relative_header_offset

      def initialize(data = nil)
        # We don't actually know what this extra field contains without
        # looking for markers in the associated file header. Store raw data
        # in @content for now, then call parse once we have the markers.
        @content                = data
        @original_size          = nil
        @compressed_size        = nil
        @relative_header_offset = nil
        @disk_start_number      = nil
      end

      def self.build(size, compressed, header_offset = nil, disk_start = nil)
        zip64 = new
        zip64.original_size = size
        zip64.compressed_size = compressed
        zip64.relative_header_offset = header_offset
        zip64.disk_start_number = disk_start
        zip64
      end

      def merge(data)
        return if data.empty?

        @content = data
      end

      # pass the values from the base entry (if applicable)
      # wider values are only present in the extra field for base values set to all FFs
      # returns the final values for the four attributes (from the base or zip64 extra record)
      def parse(size, compressed_size, header_offset = nil, disk_start = nil)
        @original_size = extract(8) if size == 0xFFFFFFFF
        @compressed_size = extract(8) if compressed_size == 0xFFFFFFFF
        if header_offset && header_offset == 0xFFFFFFFF
          @relative_header_offset = extract(8)
        end
        @disk_start_number = extract(4) if disk_start && disk_start == 0xFFFF

        @content = nil

        [
          @original_size || size,
          @compressed_size || compressed_size,
          @relative_header_offset || header_offset,
          @disk_start_number || disk_start
        ]
      end

      def to_local_bin
        # Local header entries MUST contain the original size and
        # compressed size. Other fields do not apply.
        return '' unless @original_size && @compressed_size

        [@original_size, @compressed_size].pack('Q<Q<')
      end

      def to_c_dir_bin
        # Central directory entries contain all fields that are set.
        [
          [@original_size, 'Q<'],
          [@compressed_size, 'Q<'],
          [@relative_header_offset, 'Q<'],
          [@disk_start_number, 'V']
        ].reduce('') { |acc, d| d[0].nil? ? acc : acc + [d[0]].pack(d[1]) }
      end

      def local_size
        @original_size && @compressed_size ? 16 : 0
      end

      def c_dir_size
        [
          [@original_size, 8],
          [@compressed_size, 8],
          [@relative_header_offset, 8],
          [@disk_start_number, 4]
        ].reduce(0) { |acc, d| d[0].nil? ? acc : acc + d[1] }
      end

      def ==(comp)
        comp.original_size == @original_size &&
          comp.compressed_size == @compressed_size &&
          comp.relative_header_offset == @relative_header_offset &&
          comp.disk_start_number == @disk_start_number
      end

      private

      def extract(size)
        format = size == 8 ? 'Q<' : 'V'
        @content.slice!(0, size).unpack1(format)
      end
    end
  end
end
