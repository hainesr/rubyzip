# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/extra_fields/ntfs'

class NTFSTest < Minitest::Test
  def setup
    data = "\x00\x00\x00\x00\x01\x00\x18\x00\xC0\x81\x17\xE8B\xCE\xCF\x01" \
           "\xC0\x81\x17\xE8B\xCE\xCF\x01\xC0\x81\x17\xE8B\xCE\xCF\x01"

    @ntfs = Rubyzip::ExtraFields::NTFS.new(data)
  end

  def test_parse
    t = Time.at(1_410_496_497.405178, in: '+00:00')
    assert_equal(t, @ntfs.mtime)
    assert_equal(t, @ntfs.atime)
    assert_equal(t, @ntfs.ctime)
  end

  def test_id
    assert_equal("\n\x00", @ntfs.id)
  end

  def test_label
    assert_equal('NTFS', Rubyzip::ExtraFields::NTFS.label)
  end
end
