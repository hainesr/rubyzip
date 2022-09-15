# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/codecs/inflater'
require 'stringio'

class InflaterTest < Minitest::Test
  def test_read
    text = ::File.read(TXT_LOREM_IPSUM)

    ::File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      decompressor = Rubyzip::Codecs::Inflater.new(is, ::File.size(BIN_LOREM_IPSUM_DEFLATED))

      assert_equal(text, decompressor.read)
    end
  end

  def test_read_read_partial_lengths
    text = ::File.read(TXT_LOREM_IPSUM)
    half_len = text.length / 2

    ::File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      decompressor = Rubyzip::Codecs::Inflater.new(is, ::File.size(BIN_LOREM_IPSUM_DEFLATED))

      assert_empty(decompressor.read(0))
      assert_equal(text[(0...half_len)], decompressor.read(half_len))
      assert_equal(text[(half_len...text.length)], decompressor.read)
    end
  end

  def test_read_at_eof
    ::File.open(BIN_LOREM_IPSUM_DEFLATED, 'rb') do |is|
      decompressor = Rubyzip::Codecs::Inflater.new(is, ::File.size(BIN_LOREM_IPSUM_DEFLATED))
      decompressor.read

      assert_empty(decompressor.read(0))
      assert_empty(decompressor.read)
      assert_nil(decompressor.read(1))
    end
  end

  def test_mangled_input
    data = ::File.read(BIN_LOREM_IPSUM_DEFLATED)
    data[10, 6] = 'broken'
    is = StringIO.new(data)
    decompressor = Rubyzip::Codecs::Inflater.new(is, data.length)

    assert_raises(Zlib::DataError) do
      decompressor.read
    end
  end
end