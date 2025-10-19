# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/input_stream'

class InputStreamTest < Minitest::Test
  def test_create_from_stream
    File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      # Should not raise anything.
      Rubyzip::InputStream.new(zip)
    end
  end

  def test_get_next_entry
    File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      # Test getting the first entry. This should not raise anything.
      zis = Rubyzip::InputStream.new(zip)
      entry = zis.next_entry

      assert_instance_of(Rubyzip::Entry, entry)
      assert_equal('lorem_ipsum.txt', entry.name)
      assert_equal(Rubyzip::COMPRESSION_METHOD_DEFLATE, entry.compression_method)

      # Test getting past the last entry. This should return nil.
      assert_nil(zis.next_entry)
      assert_nil(zis.next_entry)
    end
  end

  def test_read_stored_entry
    text = File.read(TXT_LOREM_IPSUM)

    File.open(ZIP_ONE_TEXT_FILE_STOR, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)
      zis.next_entry
      contents = zis.read

      assert_equal(text, contents)
    end
  end

  def test_read_deflated_entry
    text = File.read(TXT_LOREM_IPSUM)

    File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)
      zis.next_entry
      contents = zis.read

      assert_equal(text, contents)
    end
  end
end
