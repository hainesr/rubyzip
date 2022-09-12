# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'universal_time'
require_relative 'unix3'

##
module Rubyzip
  module ExtraFields
    register_extra_field_type(UniversalTime, :atime, :ctime, :mtime)
    register_extra_field_type(Unix3, :version, :uid, :gid)
  end
end
