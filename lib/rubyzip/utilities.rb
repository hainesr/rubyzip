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

      [name, header_data.slice(0...LOC_OFF_NAME_LEN), extras]
    end

    def read(data, size, offset = 0)
      method = "read#{size}".to_sym
      __send__(method, data, offset)
    end

    def read1(data, offset = 0)
      data[offset].unpack1('C')
    end

    def read2(data, offset = 0)
      data[offset, 2].unpack1('v')
    end

    def read4(data, offset = 0)
      data[offset, 4].unpack1('V')
    end

    def read4s(data, offset = 0)
      data[offset, 4].unpack1('l<')
    end

    def read8(data, offset = 0)
      data[offset, 8].unpack1('Q<')
    end
  end
end
