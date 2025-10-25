# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'universal_time'
require_relative 'unix3'
require_relative 'zip64'

##
module Rubyzip
  module ExtraFields # :nodoc:
    register_extra_field_type(UniversalTime, :atime, :ctime, :mtime)
    register_extra_field_type(Unix3, :gid, :uid, :version)
    register_extra_field_type(Zip64)
  end
end
