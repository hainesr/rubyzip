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
    # This data checks an unsupported field then a supported field
    # with no payload.
    efs = Rubyzip::ExtraFields::Set.new("xx\x01\x00\x00UT\x01\x00")
    assert_equal(0, efs.length)
    assert_equal(0, efs.size)
  end

  def test_new
    extra_data = ::File.read(BIN_LOCAL_HEADER).slice(0x2d..0x49)
    efs = Rubyzip::ExtraFields::Set.new(extra_data)

    assert_equal(2, efs.length)
    refute_nil(efs['UniversalTime'])

    mtime = Time.utc(2022, 8, 21, 13, 58, 20)
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

    assert_nil(efs.delegate(:ctime))

    mtime = Time.utc(2022, 8, 21, 13, 58, 20)
    assert_equal(mtime, efs.delegate(:mtime))

    atime = Time.utc(2022, 8, 21, 13, 58, 22)
    assert_equal(atime, efs.delegate(:atime))
  end

  def test_delegate_with_no_fields
    efs = Rubyzip::ExtraFields::Set.new

    assert_raises(NoMethodError) do
      efs.delegate(:mtime)
    end
  end
end
