# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'constants'
require_relative 'errors'

##
module Rubyzip
  module Utilities # :nodoc:
    UNPACK_BYTES = {
      1 => 'C',
      2 => 'v',
      4 => 'V',
      8 => 'Q<'
    }.freeze

    module_function

    def dos_to_ruby_time(bin_dos_date_time) # rubocop:disable Metrics/AbcSize
      year = ((bin_dos_date_time >> 25) & 0x7f) + 1980
      month = (bin_dos_date_time >> 21) & 0x0f
      day = (bin_dos_date_time >> 16) & 0x1f
      hour = (bin_dos_date_time >> 11) & 0x1f
      minute = (bin_dos_date_time >> 5) & 0x3f
      second = (bin_dos_date_time << 1) & 0x3e

      Time.local(year, month, day, hour, minute, second)
    rescue ArgumentError
      warn 'WARNING: an invalid date/time has been detected.' if Rubyzip.warn_on_invalid_date
    end

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
