# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/extra_fields/set'

class SetTest < Minitest::Test
  def test_new_nil
    efs = Rubyzip::ExtraFields::Set.new
    assert_equal(0, efs.length)
    assert_equal(0, efs.size)
  end

  def test_new_empty
    efs = Rubyzip::ExtraFields::Set.new('')
    assert_equal(0, efs.length)
    assert_equal(0, efs.size)
  end

  def test_new_nonsense
    efs = Rubyzip::ExtraFields::Set.new('xxxx')
    assert_equal(0, efs.length)
    assert_equal(0, efs.size)
  end

  def test_new
    extra_data = ::File.read(BIN_LOCAL_HEADER).slice(0x2d..0x49)
    efs = Rubyzip::ExtraFields::Set.new(extra_data)

    assert_equal(1, efs.length)
    refute_nil(efs['UniversalTime'])

    mtime = Time.local(2022, 8, 21, 14, 58, 20)
    assert_equal(mtime, efs['UniversalTime'].mtime)
  end
end
