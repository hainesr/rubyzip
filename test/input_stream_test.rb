# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/input_stream'

class InputStreamTest < MiniTest::Test
  def test_create_from_stream
    zip = ::File.open(ZIP_ONE_TEXT_FILE, 'rb')

    # Should not raise anything.
    Rubyzip::InputStream.new(zip)
  end

  def test_get_next_entry
    zip = ::File.open(ZIP_ONE_TEXT_FILE, 'rb')
    zis = Rubyzip::InputStream.new(zip)

    entry = zis.next_entry
    assert_instance_of(Rubyzip::Entry, entry)
    assert_equal('lorem_ipsum.txt', entry.name)
  end
end
