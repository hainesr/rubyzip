# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'stored_decompressor'
require_relative 'inflater'

##
module Rubyzip
  module Codecs
    register_decompressor(StoredDecompressor)
    register_decompressor(Inflater)
  end
end
