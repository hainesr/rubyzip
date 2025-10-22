# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/entry'

class EntryTest < Minitest::Test
  def setup
    header = File.read(BIN_LOCAL_HEADER)
    @entry_name = 'lorem_ipsum.txt'
    @entry = Rubyzip::Entry.new(@entry_name)
    @entry_with_header = Rubyzip::Entry.new(@entry_name, header)
  end

  def test_compressed_size
    assert_nil(@entry.compressed_size)
    assert_equal(1439, @entry_with_header.compressed_size)
  end

  def test_compression_method
    assert_nil(@entry.compression_method)
    assert_equal(Rubyzip::COMPRESSION_METHOD_DEFLATE, @entry_with_header.compression_method)
  end

  def test_crc32
    assert_nil(@entry.crc32)
    assert_equal(0xBB66B4EC, @entry_with_header.crc32)
  end

  def test_directory?
    entry = Rubyzip::Entry.new('this_is_a_directory/')

    refute_predicate(@entry, :directory?)
    refute_predicate(@entry_with_header, :directory?)
    assert_predicate(entry, :directory?)
  end

  def test_encrypted?
    refute_predicate(@entry, :encrypted?)
    refute_predicate(@entry_with_header, :encrypted?)
  end

  def test_name
    assert_equal(@entry_name, @entry.name)
    assert_equal(@entry_name, @entry_with_header.name)
  end

  def test_name_size_limit_ascii
    name = 'a' * Rubyzip::LIMIT_ENTRY_NAME_SIZE

    # Should not raise anything.
    Rubyzip::Entry.new(name)

    name += 'a'
    assert_raises(ArgumentError) do
      Rubyzip::Entry.new(name)
    end
  end

  def test_name_size_limit_utf8
    # Each '£' character takes 2 bytes in UTF-8, so add an 'a' to be on the limit.
    name = "a#{'£' * (Rubyzip::LIMIT_ENTRY_NAME_SIZE / 2)}"

    # Should not raise anything.
    Rubyzip::Entry.new(name)

    name += 'a' # Add one more byte.
    assert_raises(ArgumentError) do
      Rubyzip::Entry.new(name)
    end
  end

  def test_streamed?
    refute_predicate(@entry, :streamed?)
    refute_predicate(@entry_with_header, :streamed?)
  end

  def test_uncompressed_size
    assert_nil(@entry.uncompressed_size)
    assert_equal(3666, @entry_with_header.uncompressed_size)
  end

  def test_utf8?
    refute_predicate(@entry, :utf8?)
    refute_predicate(@entry_with_header, :utf8?)
  end

  def test_version_needed_to_extract
    assert_equal(10, @entry.version_needed_to_extract)
    assert_equal(20, @entry_with_header.version_needed_to_extract)
  end
end
