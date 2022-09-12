# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip
  module ExtraFields # :nodoc:
    @field_types = {}
    @methods_map = Hash.new { |h, k| h[k] = [] }

    def self.register_extra_field_type(clazz, *methods)
      return unless clazz.const_defined?(:EXTRA_FIELD_ID)

      @field_types[clazz.const_get(:EXTRA_FIELD_ID)] = clazz
      methods.each { |m| @methods_map[m].unshift(clazz.label) }
    end

    def self.extra_field_type_for(id)
      @field_types[id]
    end

    def self.extra_field_for_method(symbol)
      @methods_map[symbol].first
    end
  end
end

require_relative 'extra_fields/extra_fields'
