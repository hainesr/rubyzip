# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'ntfs'
require_relative 'universal_time'
require_relative 'unix3'
require_relative 'zip64'

##
module Rubyzip
  module ExtraFields
    # The order of these lines is important when there are fields which
    # provide the same methods: the later lines will gazump the earlier lines
    # when calling the methods.
    #
    # For example, below, UniversalTime is preferred over NTFS. This is
    # correct as UniversalTime is the more modern field.
    register_extra_field_type(NTFS, :atime, :ctime, :mtime)
    register_extra_field_type(UniversalTime, :atime, :ctime, :mtime)
    register_extra_field_type(Unix3, :version, :uid, :gid)
    register_extra_field_type(Zip64)
  end
end
