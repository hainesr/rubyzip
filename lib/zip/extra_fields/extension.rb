require_relative 'abstract'

module Zip
  module ExtraFields
    class Extension < Abstract
      PROVIDES = :obsolete

      def self.attr_reader(*syms)
        super

        ExtraFieldSet.register_extra_field_methods(self, *syms)

        nil
      end

      def self.attr_accessor(*syms)
        super

        ExtraFieldSet.register_extra_field_methods(self, *syms)

        nil
      end

      def self.attr_writer(*syms)
        super

        ExtraFieldSet.register_extra_field_methods(self, *syms)

        nil
      end

      def provides
        PROVIDES
      end
    end
  end
end
