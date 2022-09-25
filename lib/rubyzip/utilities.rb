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

    def read_streaming_header(io)
      sig = io.read(4)

      # If we have a signature then read 12 bytes. If not then we already
      # have the CRC-32 field, so just read 8 bytes and join them up.
      if read4(sig) == STR_SIGN
        io.read(12)
      else
        sig + io.read(8)
      end
    end

    def read_end_central_directory_records(io) # rubocop:disable Metrics
      begin
        io.seek(-CEN_MAX_END_RECORD_SIZE, IO::SEEK_END)
      rescue Errno::EINVAL
        io.seek(0, IO::SEEK_SET)
      end

      base_location = io.tell
      data = io.read
      end_location = data.rindex([CEN_END_RECORD_SIGN].pack('V'))
      raise Error, 'Zip end of central directory signature not found.' unless end_location

      end_data = data.slice(end_location..)

      zip64_end_locator = data.rindex([CEN_Z64_END_RECORD_LOC_SIGN].pack('V'))

      zip64_end_data =
        if zip64_end_locator
          zip64_end_location = data.rindex([CEN_Z64_END_RECORD_SIGN].pack('V'))

          if zip64_end_location
            data.slice(zip64_end_location..zip64_end_locator)
          else
            zip64_end_location = unpack_64_end_locator(data.slice(zip64_end_locator..end_location))
            raise Error, 'Zip64 end of central directory signature not found.' unless zip64_end_location

            io.seek(zip64_end_location, IO::SEEK_SET)
            io.read(base_location + zip64_end_locator - zip64_end_location)
          end
        end

      unpack_end_central_directory_records(end_data, zip64_end_data)
    end

    def unpack_64_end_locator(data)
      _, _, zip64_end_offset, = data.unpack(CEN_Z64_END_RECORD_LOC_PACK)

      zip64_end_offset
    end

    def unpack_end_central_directory_records(end_data, zip64_end_data)
      _, _, _, _, num_entries, _, cdir_offset, = end_data.unpack(CEN_END_RECORD_PACK)

      unless zip64_end_data.nil?
        sig, _, _, _, _, _, _, z64_num_entries, _,
        z64_cdir_offset = zip64_end_data.unpack(CEN_Z64_END_RECORD_PACK)
        raise Error, 'Zip64 end of central directory signature not found.' unless sig == CEN_Z64_END_RECORD_SIGN

        num_entries = z64_num_entries if num_entries == ZIP64_MASK_2B
        cdir_offset = z64_cdir_offset if cdir_offset == ZIP64_MASK_4B
      end

      [num_entries, cdir_offset, end_data.slice(CEN_END_RECORD_SIZE..)]
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
