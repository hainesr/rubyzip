# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/extra_fields/zip64'

class Zip64Test < Minitest::Test
  def setup
    # This data is only sufficient to test local header Zip64 extentions.
    data = "\xE2\x01\x00\x00\x00\x00\x00\x00\xE5\x00\x00\x00\x00\x00\x00\x00"
    @zip64 = Rubyzip::ExtraFields::Zip64.new(data)
  end

  def test_fields
    assert_equal(0x00000000000001E2, @zip64.uncompressed_size)
    assert_equal(0x00000000000000E5, @zip64.compressed_size)
  end
end
