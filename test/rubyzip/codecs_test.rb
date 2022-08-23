# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/codecs'

class CodecsTest < Minitest::Test
  TEST_METHOD_NOT_STORED = -99
  TEST_DECOMPRESSION_METHOD = -1

  # Fake decompressor.
  class TestDecompressor
    DECOMPRESSION_METHOD = TEST_DECOMPRESSION_METHOD
  end

  # Fake entry which uses fake decompressor.
  class TestEntry
    attr_reader :compression_method

    def initialize
      @compression_method = TEST_DECOMPRESSION_METHOD
    end
  end

  def setup
    Rubyzip::Codecs.register_decompressor(TestDecompressor)
  end

  def test_register_non_codecs
    Rubyzip::Codecs.register_decompressor(String)

    refute(Rubyzip::Codecs.instance_variable_get(:@decompressors).value?(String))
  end

  def test_decompressor_for
    assert_equal(
      TestDecompressor,
      Rubyzip::Codecs.decompressor_for(TEST_DECOMPRESSION_METHOD)
    )

    assert_nil(Rubyzip::Codecs.decompressor_for(TEST_METHOD_NOT_STORED))
  end

  def test_decompressor_for_entry
    entry = TestEntry.new

    assert_equal(
      TestDecompressor,
      Rubyzip::Codecs.decompressor_for_entry(entry)
    )
  end
end
