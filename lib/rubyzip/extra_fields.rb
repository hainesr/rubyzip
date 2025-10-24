# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip
  module ExtraFields # :nodoc:
    @field_types = {}

    def self.register_extra_field_type(clazz)
      return unless clazz.const_defined?(:EXTRA_FIELD_ID)

      @field_types[clazz.const_get(:EXTRA_FIELD_ID)] = clazz
    end

    def self.extra_field_type_for(id)
      @field_types[id]
    end
  end
end

require_relative 'extra_fields/extra_fields'
