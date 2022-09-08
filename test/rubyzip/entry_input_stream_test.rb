# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/entry_input_stream'
require 'stringio'

class EntryInputStreamTest < Minitest::Test # rubocop:disable Metrics/ClassLength
  def test_read_stored_entry
    text = File.read(TXT_LOREM_IPSUM)

    entry = Minitest::Mock.new
    entry.expect(:compressed_size, text.length)
    entry.expect(:compression_method, Rubyzip::COMPRESSION_METHOD_STORE)
    entry.expect(:crc32, 0xbb66b4ec)
    entry.expect(:encrypted?, false)
    entry.expect(:uncompressed_size, text.length)

    File.open(TXT_LOREM_IPSUM, 'rb') do |is|
      eis = Rubyzip::EntryInputStream.new(is, entry)

      assert_equal(text, eis.read)
      eis.validate_crc32!
    end

    entry.verify
  end

  def test_read_deflated_entry
    text = File.read(TXT_LOREM_IPSUM)

    entry = Minitest::Mock.new
    entry.expect(:compressed_size, File.size(BIN_LOREM_IPSUM_DEFLATED))
    entry.expect(:compression_method, Rubyzip::COMPRESSION_METHOD_DEFLATE)
    entry.expect(:crc32, 0xbb66b4ec)
    entry.expect(:encrypted?, false)
    entry.expect(:uncompressed_size, text.length)

    File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      eis = Rubyzip::EntryInputStream.new(is, entry)

      assert_equal(text, eis.read)
      eis.validate_crc32!
    end

    entry.verify
  end

  def test_read_partial_lengths # rubocop:disable Metrics/AbcSize
    text = File.read(TXT_LOREM_IPSUM)
    half_len = text.length / 2

    entry = Minitest::Mock.new
    entry.expect(:compressed_size, text.length)
    entry.expect(:compression_method, Rubyzip::COMPRESSION_METHOD_STORE)
    entry.expect(:crc32, 0xbb66b4ec)
    entry.expect(:encrypted?, false)
    entry.expect(:uncompressed_size, text.length)
    entry.expect(:uncompressed_size, text.length)
    entry.expect(:uncompressed_size, text.length)

    File.open(TXT_LOREM_IPSUM, 'rb') do |is|
      eis = Rubyzip::EntryInputStream.new(is, entry)

      assert_empty(eis.read(0))
      assert_equal(text[(0...half_len)], eis.read(half_len))
      assert_equal(text[(half_len...text.length)], eis.read)
      eis.validate_crc32!
    end

    entry.verify
  end

  def test_read_at_eof # rubocop:disable Metrics/AbcSize
    entry = Minitest::Mock.new
    entry.expect(:compressed_size, File.size(BIN_LOREM_IPSUM_DEFLATED))
    entry.expect(:compression_method, Rubyzip::COMPRESSION_METHOD_DEFLATE)
    entry.expect(:encrypted?, false)
    entry.expect(:uncompressed_size, File.size(TXT_LOREM_IPSUM))

    File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      eis = Rubyzip::EntryInputStream.new(is, entry)

      eis.read

      assert_empty(eis.read)
      assert_empty(eis.read(0))
      assert_nil(eis.read(1))
    end

    entry.verify
  end

  def test_read_encrypted_stored_entry
    text = File.read(TXT_LOREM_IPSUM)

    entry = Minitest::Mock.new
    entry.expect(:compressed_size, File.size(BIN_LOREM_IPSUM_ENC))
    entry.expect(:compression_method, Rubyzip::COMPRESSION_METHOD_STORE)
    entry.expect(:crc32, 0xbb66b4ec)
    entry.expect(:encrypted?, true)
    entry.expect(:uncompressed_size, text.length)

    File.open(BIN_LOREM_IPSUM_ENC, 'rb') do |is|
      eis = Rubyzip::EntryInputStream.new(is, entry, 'Rubyz1p!')

      assert_equal(text, eis.read)
      eis.validate_crc32!
    end

    entry.verify
  end

  def test_warn_on_too_long_input # rubocop:disable Metrics/AbcSize
    fake_size = 100
    entry = Minitest::Mock.new
    entry.expect(:compressed_size, File.size(BIN_LOREM_IPSUM_DEFLATED))
    entry.expect(:compression_method, Rubyzip::COMPRESSION_METHOD_DEFLATE)
    entry.expect(:encrypted?, false)
    entry.expect(:name, 'test_entry')
    entry.expect(:uncompressed_size, fake_size)
    entry.expect(:uncompressed_size, fake_size)
    entry.expect(:uncompressed_size, fake_size)

    File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      eis = Rubyzip::EntryInputStream.new(is, entry)

      assert_silent { eis.read(50) }
      assert_output('', /.+'test_entry'.+#{fake_size}B.+/) do
        eis.read(100)
      end
      assert_silent { eis.read(50) } # Should only warn once.
    end

    entry.verify
  end

  def test_detect_invalid_crc32 # rubocop:disable Metrics/AbcSize
    text = StringIO.new('Test text of 29 characters...')

    entry = Minitest::Mock.new
    entry.expect(:compressed_size, text.length)
    entry.expect(:compression_method, Rubyzip::COMPRESSION_METHOD_STORE)
    entry.expect(:crc32, 0x12345678)
    entry.expect(:crc32, 0x12345678)
    entry.expect(:encrypted?, false)
    entry.expect(:uncompressed_size, text.length)

    eis = Rubyzip::EntryInputStream.new(text, entry)

    assert_equal(text.string, eis.read)
    error = assert_raises(Rubyzip::CRC32Error) { eis.validate_crc32! }
    assert_match(/expected 0x12345678/, error.message)
    entry.verify
  end
end
