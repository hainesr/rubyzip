# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/entry'

class EntryTest < MiniTest::Test
  def test_create_with_name
    name = 'Entry_name.txt'
    entry = Rubyzip::Entry.new(name)

    assert_equal(name, entry.name)
    assert_nil(entry.compression_method)
    assert_nil(entry.crc32)
  end

  def test_create_with_name_and_header
    name = 'lorem_ipsum.txt'
    header = ::File.read(BIN_LOCAL_HEADER)
    entry = Rubyzip::Entry.new(name, header: header)

    assert_equal(name, entry.name)
    assert_equal(Rubyzip::COMPRESSION_METHOD_DEFLATE, entry.compression_method)
    assert_equal(0xBB66B4EC, entry.crc32)
  end
end
