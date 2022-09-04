# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/codecs/inflater'
require 'stringio'

class InflaterTest < Minitest::Test
  # Fake entry which implements compressed_size, name and uncompressed_size.
  class TestEntry
    attr_reader :compressed_size, :name, :uncompressed_size

    def initialize(data_size, full_size)
      @name = 'test_entry'
      @compressed_size = data_size
      @uncompressed_size = full_size
    end
  end

  def test_read
    text = File.read(TXT_LOREM_IPSUM)

    File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      entry = TestEntry.new(File.size(BIN_LOREM_IPSUM_DEFLATED), text.length)
      decompressor = Rubyzip::Codecs::Inflater.new(is, entry)

      assert_equal(text, decompressor.read)
    end
  end

  def test_read_read_partial_lengths # rubocop:disable Metrics/AbcSize
    text = ::File.read(TXT_LOREM_IPSUM)
    half_len = text.length / 2

    File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      entry = TestEntry.new(File.size(BIN_LOREM_IPSUM_DEFLATED), text.length)
      decompressor = Rubyzip::Codecs::Inflater.new(is, entry)

      assert_empty(decompressor.read(0))
      assert_equal(text[(0...half_len)], decompressor.read(half_len))
      assert_equal(text[(half_len...text.length)], decompressor.read)
    end
  end

  def test_read_at_eof
    File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      entry = TestEntry.new(File.size(BIN_LOREM_IPSUM_DEFLATED), File.size(TXT_LOREM_IPSUM))
      decompressor = Rubyzip::Codecs::Inflater.new(is, entry)
      decompressor.read

      assert_empty(decompressor.read(0))
      assert_empty(decompressor.read)
      assert_nil(decompressor.read(1))
    end
  end

  def test_mangled_input
    data = File.read(BIN_LOREM_IPSUM_DEFLATED)
    data[10, 6] = 'broken'
    is = StringIO.new(data)
    entry = TestEntry.new(data.length, ::File.size(TXT_LOREM_IPSUM))
    decompressor = Rubyzip::Codecs::Inflater.new(is, entry)

    assert_raises(Zlib::DataError) do
      decompressor.read
    end
  end

  def test_warn_on_long_input
    text_length = ::File.size(TXT_LOREM_IPSUM)
    ::File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      entry = TestEntry.new(::File.size(BIN_LOREM_IPSUM_DEFLATED), text_length - 1)
      decompressor = Rubyzip::Codecs::Inflater.new(is, entry)

      # Assert that the uncompressed data is detected as too long, but it should
      # still uncompress the whole thing.
      assert_output('', /.+'test_entry'.+#{entry.uncompressed_size}B.+/) do
        buf = decompressor.read

        assert_equal(text_length, buf.length)
      end
    end
  end

  def test_warn_only_once_on_long_input
    text_length = ::File.size(TXT_LOREM_IPSUM)
    half_length = text_length / 2
    ::File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      entry = TestEntry.new(::File.size(BIN_LOREM_IPSUM_DEFLATED), half_length)
      decompressor = Rubyzip::Codecs::Inflater.new(is, entry)

      assert_silent do
        decompressor.read(100)
      end

      assert_output('', /.+'test_entry'.+#{entry.uncompressed_size}B.+/) do
        decompressor.read(half_length)
      end

      assert_silent do
        decompressor.read
      end
    end
  end
end
