# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/utilities'

class UtilitiesTest < MiniTest::Test
  include Rubyzip::Utilities

  def test_read_local_header
    ::File.open(BIN_LOCAL_HEADER, 'rb') do |header|
      # Should not raise anything.
      name, header_data, extras = read_local_header(header)

      assert_equal('lorem_ipsum.txt', name)
      assert_equal(Rubyzip::LOC_SIZE, header_data.length)
      assert_equal(name.length + header_data.length + extras.length, header.tell)
    end
  end
end
