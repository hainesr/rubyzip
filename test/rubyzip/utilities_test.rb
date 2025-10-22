# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/utilities'
require 'stringio'

class UtilitiesTest < Minitest::Test
  include Rubyzip::Utilities

  def test_read_local_header
    File.open(BIN_LOCAL_HEADER, 'rb') do |header|
      # Should not raise anything.
      name, header_data, extras = read_local_header(header)

      assert_equal('lorem_ipsum.txt', name)
      assert_equal(Rubyzip::LOC_SIZE, header_data.length)
      assert_equal(name.length + header_data.length + extras.length, header.tell)
    end
  end

  def test_read_local_header_with_bad_signature
    header = File.read(BIN_LOCAL_HEADER)
    header[0] = 'Z'
    io = StringIO.new(header)

    assert_raises(Rubyzip::Error) do
      read_local_header(io)
    end
  end

  def test_dos_to_ruby_time
    time1 = Time.local(2022, 8, 21, 14, 58, 20)
    time2 = Time.local(2022, 8, 26, 14, 0, 32)

    assert_equal(time1, dos_to_ruby_time(0x5515774A))
    assert_equal(time2, dos_to_ruby_time(0x551A7010))
  end
end
