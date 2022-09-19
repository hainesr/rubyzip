# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'rubyzip/constants'
require_relative 'rubyzip/version'
require_relative 'rubyzip/configuration'

# Rubyzip is a ruby module for reading and writing zip files.
#
# Rubyzip is configured here at the top level. See the Configuration
# module for the details.
module Rubyzip
  extend Configuration

  reset!
end

require_relative 'rubyzip/input_stream'
