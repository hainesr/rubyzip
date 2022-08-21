# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'constants'
require_relative 'errors'

##
module Rubyzip
  module Utilities # :nodoc:
    module_function

    def read_local_header(io)
      header_data = io.read(LOC_SIZE)

      sig, _ver_extract, _fs_type, _gp_flags, _compression,
      _last_mod_time, _last_mod_date, _crc32, _comp_size, _uncomp_size,
      name_len, extra_len = header_data.unpack(LOC_PACK)

      raise Error, 'Zip local header not found.' unless sig == LOC_SIGN

      name = io.read(name_len)
      extras = io.read(extra_len)

      [name, header_data, extras]
    end
  end
end
