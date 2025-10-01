# frozen_string_literal: true

require_relative 'test_helper'

require 'zip/entry'

class ZipCentralDirectoryEntryTest < Minitest::Test
  def test_read_from_stream
    File.open('test/data/testDirectory.bin', 'rb') do |file|
      entry = ::Zip::Entry.read_c_dir_entry(file)

      assert_equal('longAscii.txt', entry.name)
      assert_equal(::Zip::Entry::DEFLATED, entry.compression_method)
      assert_equal(106_490, entry.size)
      assert_equal(3784, entry.compressed_size)
      assert_equal(0xfcd1799c, entry.crc)
      assert_equal('', entry.comment)

      entry = ::Zip::Entry.read_c_dir_entry(file)
      assert_equal('empty.txt', entry.name)
      assert_equal(::Zip::Entry::STORED, entry.compression_method)
      assert_equal(0, entry.size)
      assert_equal(0, entry.compressed_size)
      assert_equal(0x0, entry.crc)
      assert_equal('', entry.comment)

      entry = ::Zip::Entry.read_c_dir_entry(file)
      assert_equal('short.txt', entry.name)
      assert_equal(::Zip::Entry::STORED, entry.compression_method)
      assert_equal(6, entry.size)
      assert_equal(6, entry.compressed_size)
      assert_equal(0xbb76fe69, entry.crc)
      assert_equal('', entry.comment)

      entry = ::Zip::Entry.read_c_dir_entry(file)
      assert_equal('longBinary.bin', entry.name)
      assert_equal(::Zip::Entry::DEFLATED, entry.compression_method)
      assert_equal(1_000_024, entry.size)
      assert_equal(70_847, entry.compressed_size)
      assert_equal(0x10da7d59, entry.crc)
      assert_equal('', entry.comment)

      entry = ::Zip::Entry.read_c_dir_entry(file)
      assert_nil(entry)
      # Fields that are not check by this test:
      #          version made by                 2 bytes
      #          version needed to extract       2 bytes
      #          general purpose bit flag        2 bytes
      #          last mod file time              2 bytes
      #          last mod file date              2 bytes
      #          compressed size                 4 bytes
      #          uncompressed size               4 bytes
      #          disk number start               2 bytes
      #          internal file attributes        2 bytes
      #          external file attributes        4 bytes
      #          relative offset of local header 4 bytes

      #          file name (variable size)
      #          extra field (variable size)
      #          file comment (variable size)
    end
  end

  def test_read_entry_from_truncated_zip_file_raises_error
    File.open('test/data/testDirectory.bin') do |f|
      # cdir entry header is at least 46 bytes, so just read a bit.
      fragment = f.read(12)
      assert_raises(::Zip::Error) do
        entry = ::Zip::Entry.new
        entry.read_c_dir_entry(StringIO.new(fragment))
      end
    end
  end

  def test_read_entry_from_truncated_zip_file_returns_nil
    File.open('test/data/testDirectory.bin') do |f|
      # cdir entry header is at least 46 bytes, so just read a bit.
      fragment = f.read(12)
      assert_nil(::Zip::Entry.read_c_dir_entry(StringIO.new(fragment)))
    end
  end

  def test_read_corrupted_entry_raises_error
    fragment = File.binread('test/data/testDirectory.bin')
    fragment.slice!(12)
    io = StringIO.new(fragment)
    assert_raises(::Zip::Error) do
      entry = ::Zip::Entry.new
      entry.read_c_dir_entry(io)
      # First entry will be read but break later entries.
      entry.read_c_dir_entry(io)
    end
  end

  def test_read_corrupted_entry_returns_nil
    fragment = File.binread('test/data/testDirectory.bin')
    fragment.slice!(12)
    io = StringIO.new(fragment)
    refute_nil(::Zip::Entry.read_c_dir_entry(io))
    # First entry will be read but break later entries.
    assert_nil(::Zip::Entry.read_c_dir_entry(io))
  end
end
