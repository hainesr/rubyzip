# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/utilities'
require 'stringio'

class UtilitiesTest < Minitest::Test
  include Rubyzip::Utilities

  def test_read_local_header
    ::File.open(BIN_LOCAL_HEADER, 'rb') do |header|
      # Should not raise anything.
      name, header_data, extras = read_local_header(header)

      assert_equal('lorem_ipsum.txt', name)

      # We throw away the header data for name length and extras length.
      assert_equal(Rubyzip::LOC_SIZE - 4, header_data.length)
      assert_equal(name.length + header_data.length + extras.length, header.tell - 4)
    end
  end

  def test_read_local_header_with_bad_signature
    header = ::File.binread(BIN_LOCAL_HEADER)
    header[0] = 'Z'
    io = StringIO.new(header)

    assert_raises(Rubyzip::Error) do
      read_local_header(io)
    end
  end

  def test_read_streaming_header_with_sig
    header = [0x08074b50, 0xbb66b4ec, 0x59f, 0xe52].pack('VVVV')
    header_stream = StringIO.new(header)

    assert_equal(header.slice(4..), read_streaming_header(header_stream))
  end

  def test_read_streaming_header_no_sig
    header = [0xbb66b4ec, 0x59f, 0xe52].pack('VVV')
    header_stream = StringIO.new(header)

    assert_equal(header, read_streaming_header(header_stream))
  end

  def test_unpack_cdir_end_records
    record = ::File.binread(BIN_CDIR_END_RECORD)
    num, offset, comment = unpack_end_central_directory_records(record, nil)

    assert_equal(2, num)
    assert_equal(0xb6f, offset)
    assert_empty(comment)
  end

  def test_unpack_cdir_end_records_zip64
    data = ::File.binread(BIN_CDIR_END_RECORD_ZIP64)
    record_zip64 = data.slice!(0...Rubyzip::CEN_Z64_END_RECORD_SIZE)
    record = data.slice!(Rubyzip::CEN_Z64_END_RECORD_LOC_SIZE..)
    num, offset, comment = unpack_end_central_directory_records(record, record_zip64)

    assert_equal(2, num)
    assert_equal(0x240, offset)
    assert_empty(comment)
  end

  def test_read_cdir_end_records
    ::File.open(BIN_CDIR_END_RECORD, 'rb') do |record|
      num, offset, comment = read_end_central_directory_records(record)

      assert_equal(2, num)
      assert_equal(0xb6f, offset)
      assert_empty(comment)
    end
  end

  def test_read_cdir_end_records_with_no_end_record
    data = ("\x00" * 4) + ::File.binread(BIN_CDIR_END_RECORD).slice(4..)
    record = StringIO.new(data)

    error = assert_raises(Rubyzip::Error) do
      read_end_central_directory_records(record)
    end

    assert_match(/Zip end of central directory signature not found/, error.message)
  end

  def test_read_cdir_end_records_zip64
    ::File.open(BIN_CDIR_END_RECORD_ZIP64, 'rb') do |record|
      num, offset, comment = read_end_central_directory_records(record)

      assert_equal(2, num)
      assert_equal(0x240, offset)
      assert_empty(comment)
    end
  end

  def test_read_cdir_end_records_zip64_with_no_zip64_end_record
    data = ("\x00" * 1000) + ::File.binread(BIN_CDIR_END_RECORD_ZIP64).slice(4..)
    record = StringIO.new(data)

    error = assert_raises(Rubyzip::Error) do
      read_end_central_directory_records(record)
    end

    assert_match(/Zip64 end of central directory signature not found/, error.message)
  end

  def test_read
    header = ::File.binread(BIN_LOCAL_HEADER)

    assert_equal(0x50, read(header, 1))
    assert_equal(0x4b50, read(header, 2))
    assert_equal(0x04034b50, read(header, 4))
  end

  def test_read2
    header = ::File.binread(BIN_LOCAL_HEADER)

    assert_equal(0x4b50, read2(header))
    assert_equal(Rubyzip::COMPRESSION_METHOD_DEFLATE, read2(header, 8))
  end

  def test_read4
    header = ::File.binread(BIN_LOCAL_HEADER)

    assert_equal(0x04034b50, read4(header))
    assert_equal(3666, read4(header, 22))
  end

  def test_read8
    header = ::File.binread(BIN_LOCAL_HEADER)

    assert_equal(0x1404034b50, read8(header))
    assert_equal(0x774a000800000014, read8(header, 4))
  end

  def test_dos_to_ruby_time
    time1 = Time.local(2022, 8, 21, 14, 58, 20)
    assert_equal(time1, dos_to_ruby_time(0x5515774A))

    time2 = Time.local(2022, 8, 26, 14, 0, 32)
    assert_equal(time2, dos_to_ruby_time(0x551A7010))
  end

  def test_dos_to_ruby_time_invalid_date
    bad_date = 0x45A195EA

    assert_output('', /WARNING: an invalid date\/time has been detected\./) do
      dos_to_ruby_time(bad_date)
    end

    assert_silent do
      Rubyzip.stub :warn_on_invalid_date, false do
        dos_to_ruby_time(bad_date)
      end
    end
  end
end
