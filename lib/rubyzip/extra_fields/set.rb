# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'forwardable'

require_relative '../extra_fields'

##
module Rubyzip
  module ExtraFields # :nodoc:
    class Set # :nodoc:
      extend Forwardable

      def_delegators :@fields, :[], :length, :size

      def initialize(data = nil)
        @fields = {}
        merge(data.dup) unless data.nil?
      end

      def delegate(symbol, *_args)
        field = @fields[ExtraFields.extra_field_for_method(symbol)]
        field.__send__(symbol)
      end

      def respond_to_missing?(symbol, _)
        !@fields[ExtraFields.extra_field_for_method(symbol)].nil?
      end

      private

      def merge(data)
        while data.bytesize.positive?
          id = data.slice!(0, 2)
          size = data.slice!(0, 2).unpack1('v')
          next if size.nil? || size > data.bytesize

          payload = data.slice!(0, size)
          field_type = ExtraFields.extra_field_type_for(id)
          next if field_type.nil? || payload.empty?

          @fields[field_type.label] = field_type.new(payload)
        end
      end
    end
  end
end
