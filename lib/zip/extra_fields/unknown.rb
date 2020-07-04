require_relative 'abstract'

module Zip
  module ExtraFields
    class Unknown < Abstract
      EXTRA_FIELD_ID = ''

      def initialize(data)
        @data = data
      end

      def merge(data)
        @data ||= data # rubocop:disable Naming/MemoizedInstanceVariableName
      end

      def to_local_bin
        @data
      end

      def to_c_dir_bin
        @data
      end
    end
  end
end
