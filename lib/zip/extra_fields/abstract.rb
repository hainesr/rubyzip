module Zip
  module ExtraFields
    class Abstract
      def self.register_extra_field_type
        ExtraFieldSet.register_extra_field_type(self)
      end

      def to_local_bin
        ''
      end

      def to_c_dir_bin
        ''
      end

      def local_size
        to_local_bin.bytesize
      end

      def c_dir_size
        to_c_dir_bin.bytesize
      end

      def ==(other)
        return false if self.class != other.class

        to_local_bin == other.to_local_bin && to_c_dir_bin == other.to_c_dir_bin
      end
    end
  end
end
