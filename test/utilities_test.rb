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
    header = ::File.binread(BIN_LOCAL_HEADER)
    header[0] = 'Z'
    io = StringIO.new(header)

    assert_raises(Rubyzip::Error) do
      read_local_header(io)
    end
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
end
