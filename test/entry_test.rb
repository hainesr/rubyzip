# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/entry'

class EntryTest < MiniTest::Test
  def setup
    header = ::File.read(BIN_LOCAL_HEADER)
    @entry_name = 'lorem_ipsum.txt'
    @entry = Rubyzip::Entry.new(@entry_name)
    @entry_with_header = Rubyzip::Entry.new(@entry_name, header: header)
  end

  def test_create
    assert_equal(@entry_name, @entry.name)
    assert_equal(@entry_name, @entry_with_header.name)
  end

  def test_compressed_size
    assert_nil(@entry.compressed_size)
    assert_equal(1439, @entry_with_header.compressed_size)
  end

  def test_compression_method
    assert_nil(@entry.compression_method)
    assert_equal(
      Rubyzip::COMPRESSION_METHOD_DEFLATE,
      @entry_with_header.compression_method
    )
  end

  def test_crc32
    assert_nil(@entry.crc32)
    assert_equal(0xBB66B4EC, @entry_with_header.crc32)
  end

  def test_uncompressed_size
    assert_nil(@entry.uncompressed_size)
    assert_equal(3666, @entry_with_header.uncompressed_size)
  end
end
