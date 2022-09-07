# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/crypto/traditional_decrypter'

class TraditionalDecrypterTest < Minitest::Test
  def test_decrypt_text
    text = ::File.read(TXT_LOREM_IPSUM)
    ::File.open(BIN_LOREM_IPSUM_ENC, 'rb') do |is|
      decrypter = Rubyzip::Crypto::TraditionalDecrypter.new(is, 'Rubyz1p!')
      assert_equal(text, decrypter.read)
    end
  end

  def test_decrypt_partial_lengths
    text = ::File.read(TXT_LOREM_IPSUM)
    half_len = text.length / 2

    ::File.open(BIN_LOREM_IPSUM_ENC, 'rb') do |is|
      decrypter = Rubyzip::Crypto::TraditionalDecrypter.new(is, 'Rubyz1p!')

      assert_empty(decrypter.read(0))
      assert_equal(text[(0...half_len)], decrypter.read(half_len))
      assert_equal(text[(half_len...text.length)], decrypter.read)
    end
  end

  def test_bad_password
    text = ::File.read(TXT_LOREM_IPSUM)
    ::File.open(BIN_LOREM_IPSUM_ENC, 'rb') do |is|
      decrypter = Rubyzip::Crypto::TraditionalDecrypter.new(is, 'Wr0ng!')
      refute_equal(text, decrypter.read)
    end
  end
end
