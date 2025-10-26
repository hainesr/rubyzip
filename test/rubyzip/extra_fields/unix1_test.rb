# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/extra_fields/unix1'

class Unix1Test < Minitest::Test
  def setup
    data = "\x9D\xA6\f_\x9D\xA6\f_\xE9\x03\xEA\x03".b
    @ux = Rubyzip::ExtraFields::Unix1.new(data)
  end

  def test_times
    time = Time.utc(2020, 7, 13, 18, 23, 25)

    assert_equal(time, @ux.atime)
    assert_equal(time, @ux.mtime)
  end

  def test_ids
    assert_equal(1001, @ux.uid)
    assert_equal(1002, @ux.gid)
  end

  def test_no_ids
    data = "\x9D\xA6\f_\x9D\xA6\f_".b
    ux = Rubyzip::ExtraFields::Unix1.new(data)

    assert_equal(Time.utc(2020, 7, 13, 18, 23, 25), ux.mtime)
    assert_nil(ux.uid)
    assert_nil(ux.gid)
  end

  def test_id
    assert_equal('UX', @ux.id)
  end

  def test_label
    assert_equal('Unix1', Rubyzip::ExtraFields::Unix1.label)
  end
end
