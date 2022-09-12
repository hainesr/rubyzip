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
      assert_equal(Rubyzip::LOC_SIZE, header_data.length)
      assert_equal(name.length + header_data.length + extras.length, header.tell)
    end
  end

  def test_read_local_header_with_bad_signature
    header = ::File.read(BIN_LOCAL_HEADER)
    header[0] = 'Z'
    io = StringIO.new(header)

    assert_raises(Rubyzip::Error) do
      read_local_header(io)
    end
  end

  def test_read
    header = ::File.read(BIN_LOCAL_HEADER)

    assert_equal(0x50, read(header, 8))
    assert_equal(0x4b50, read(header, 16))
    assert_equal(0x04034b50, read(header, 32))
  end

  def test_read16
    header = ::File.read(BIN_LOCAL_HEADER)

    assert_equal(0x4b50, read16(header))
    assert_equal(Rubyzip::COMPRESSION_METHOD_DEFLATE, read16(header, 8))
  end

  def test_read32
    header = ::File.read(BIN_LOCAL_HEADER)

    assert_equal(0x04034b50, read32(header))
    assert_equal(3666, read32(header, 22))
  end

  def test_dos_to_ruby_time
    time1 = Time.utc(2022, 8, 21, 14, 58, 20)
    assert_equal(time1, dos_to_ruby_time(0x5515774A))

    time2 = Time.utc(2022, 8, 26, 14, 0, 32)
    assert_equal(time2, dos_to_ruby_time(0x551A7010))
  end
end
