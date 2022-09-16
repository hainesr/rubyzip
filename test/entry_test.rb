# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/entry'

class EntryTest < Minitest::Test
  def setup
    ::File.open(BIN_LOCAL_HEADER, 'rb') do |header|
      @entry_name, header_data, extras = Rubyzip::Utilities.read_local_header(header)
      @entry = Rubyzip::Entry.new(@entry_name)
      @entry_with_header =
        Rubyzip::Entry.new(@entry_name, header: header_data, extra_field_data: extras)
    end
  end

  def test_create
    assert_equal(@entry_name, @entry.name)
    assert_equal(@entry_name, @entry_with_header.name)
  end

  def test_create_name_too_long
    name = 'a' * 0xFFFE

    # Should not raise anything.
    Rubyzip::Entry.new("#{name}a")

    # One character too long.
    assert_raises(ArgumentError) do
      Rubyzip::Entry.new("a#{name}a")
    end

    # Length OK, but byte size is too big due to the UTF8 character in it.
    assert_raises(ArgumentError) do
      Rubyzip::Entry.new("#{name}å")
    end
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

  def test_directory?
    refute_predicate(@entry, :directory?)
    refute_predicate(@entry_with_header, :directory?)

    entry = Rubyzip::Entry.new('this_is_a_directory/')
    assert_predicate(entry, :directory?)
  end

  def test_encrypted?
    assert_nil(@entry.encrypted?)
    refute_predicate(@entry_with_header, :encrypted?)
  end

  def test_streamed?
    assert_nil(@entry.streamed?)
    refute_predicate(@entry_with_header, :streamed?)
  end

  def test_uncompressed_size
    assert_nil(@entry.uncompressed_size)
    assert_equal(3666, @entry_with_header.uncompressed_size)
  end

  def test_utf8?
    assert_nil(@entry.utf8?)
    refute_predicate(@entry_with_header, :utf8?)
  end

  def test_version_needed_to_extract
    assert_equal(10, @entry.version_needed_to_extract)
    assert_equal(20, @entry_with_header.version_needed_to_extract)
  end

  def test_mtime
    assert_nil(@entry.mtime)

    time = Time.utc(2022, 8, 21, 13, 58, 20)
    assert_equal(time, @entry_with_header.mtime)
  end

  def test_respond_to
    assert_respond_to(@entry_with_header, :atime)
    refute_respond_to(@entry_with_header, :xtime)
    refute_respond_to(@entry, :atime)
  end

  def test_delegation_to_extra_fields
    # Should not raise anything.
    @entry_with_header.ctime

    assert_raises(NoMethodError) do
      @entry_with_header.xtime
    end

    assert_raises(NoMethodError) do
      @entry.atime
    end
  end

  def test_simple_zip64
    ::File.open(BIN_LOCAL_HEADER_ZIP64, 'rb') do |header|
      name, header_data, extras = Rubyzip::Utilities.read_local_header(header)
      entry = Rubyzip::Entry.new(name, header: header_data, extra_field_data: extras)

      assert_predicate(entry, :zip64?)
      assert_equal(229, entry.compressed_size)
      assert_equal(482, entry.uncompressed_size)
    end
  end
end
