# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
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
    mtime = Time.utc(2022, 8, 21, 13, 58, 20)

    assert_equal(2, efs.length)
    refute_nil(efs['UniversalTime'])
    assert_equal(mtime, efs['UniversalTime'].mtime)
  end

  def test_respond_to
    extra_data = ::File.read(BIN_LOCAL_HEADER).slice(0x2d..0x49)
    efs = Rubyzip::ExtraFields::Set.new(extra_data)

    assert_respond_to(efs, :mtime)
    assert_respond_to(efs, :atime)
    refute_respond_to(efs, :time)
  end

  def test_respond_to_with_no_fields
    efs = Rubyzip::ExtraFields::Set.new

    refute_respond_to(efs, :mtime)
  end

  def test_delegate
    extra_data = ::File.read(BIN_LOCAL_HEADER).slice(0x2d..0x49)
    efs = Rubyzip::ExtraFields::Set.new(extra_data)
    mtime = Time.utc(2022, 8, 21, 13, 58, 20)
    atime = Time.utc(2022, 8, 21, 13, 58, 22)

    assert_nil(efs.delegate(:ctime))
    assert_equal(mtime, efs.delegate(:mtime))
    assert_equal(atime, efs.delegate(:atime))
  end

  def test_delegate_with_no_fields
    efs = Rubyzip::ExtraFields::Set.new

    assert_raises(NoMethodError) do
      efs.delegate(:mtime)
    end
  end
end
