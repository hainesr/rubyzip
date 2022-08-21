# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/input_stream'

class InputStreamTest < MiniTest::Test
  def test_create_from_stream
    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      # Should not raise anything.
      Rubyzip::InputStream.new(zip)
    end
  end

  def test_get_next_entry
    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)

      entry = zis.next_entry
      assert_instance_of(Rubyzip::Entry, entry)
      assert_equal('lorem_ipsum.txt', entry.name)
      assert_equal(
        Rubyzip::COMPRESSION_METHOD_DEFLATE,
        entry.compression_method
      )
    end
  end

  def test_next_entry_too_far
    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)

      entry = zis.next_entry
      assert_instance_of(Rubyzip::Entry, entry)
      assert_equal('lorem_ipsum.txt', entry.name)

      entry = zis.next_entry
      assert_nil(entry)
    end
  end
end
