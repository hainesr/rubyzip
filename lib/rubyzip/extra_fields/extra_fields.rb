# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'universal_time'

##
module Rubyzip
  module ExtraFields # :nodoc:
    register_extra_field_type(UniversalTime, :atime, :ctime, :mtime)
  end
end
