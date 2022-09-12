# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../utilities'
require_relative 'field'

##
module Rubyzip
  module ExtraFields # :nodoc:
    # Info-ZIP New Unix Extra Field.
    class Unix3 < Field
      EXTRA_FIELD_ID = 'ux'

      def gid
        Utilities.read(@data, @gid_size * 8, @gid_offset)
      end

      def uid
        Utilities.read(@data, @uid_size * 8, @uid_offset)
      end

      def version
        Utilities.read8(@data)
      end

      private

      def merge
        @uid_size = Utilities.read8(@data, 1)
        @uid_offset = 2
        @gid_size = Utilities.read8(@data, @uid_offset + @uid_size)
        @gid_offset = @uid_offset + @uid_size + 1
      end
    end
  end
end
