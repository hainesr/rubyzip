# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/codecs/stored_decompressor'

class StoredDecompressorTest < Minitest::Test
  def test_read
    text = File.read(TXT_LOREM_IPSUM)

    File.open(TXT_LOREM_IPSUM, 'rb') do |is|
      decompressor = Rubyzip::Codecs::StoredDecompressor.new(is, text.length)

      assert_equal(text, decompressor.read)
    end
  end

  def test_read_read_partial_lengths
    text = File.read(TXT_LOREM_IPSUM)
    half_len = text.length / 2

    File.open(TXT_LOREM_IPSUM, 'rb') do |is|
      decompressor = Rubyzip::Codecs::StoredDecompressor.new(is, text.length)

      assert_empty(decompressor.read(0))
      assert_equal(text[(0...half_len)], decompressor.read(half_len))
      assert_equal(text[(half_len...text.length)], decompressor.read)
    end
  end

  def test_read_at_eof
    File.open(TXT_LOREM_IPSUM, 'rb') do |is|
      decompressor = Rubyzip::Codecs::StoredDecompressor.new(is, ::File.size(TXT_LOREM_IPSUM))
      decompressor.read

      assert_empty(decompressor.read(0))
      assert_empty(decompressor.read)
      assert_nil(decompressor.read(1))
    end
  end

  def test_short_input
    File.open(TXT_LOREM_IPSUM, 'rb') do |is|
      decompressor = Rubyzip::Codecs::StoredDecompressor.new(is, ::File.size(TXT_LOREM_IPSUM) + 1)
      decompressor.read

      assert_raises(EOFError) do
        decompressor.read(1)
      end
    end
  end
end
