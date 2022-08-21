# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/input_stream'

class InputStreamTest < Minitest::Test
  def test_create_from_stream
    zip = ::File.open(ZIP_ONE_TEXT_FILE, 'rb')

    # Should not raise anything.
    Rubyzip::InputStream.new(zip)
  end
end
