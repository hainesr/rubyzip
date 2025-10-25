# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip
  module ExtraFields # :nodoc:
    # This is the superclass for all extra fields.
    #
    # Subclasses are required to implement `merge` and define `EXTRA_FIELD_ID`.
    class ExtraField # :nodoc:
      def initialize(data)
        merge(data)
      end

      def self.label
        @label ||= name.split('::')[-1]
      end

      def id
        self.class.const_get(:EXTRA_FIELD_ID)
      end
    end
  end
end
