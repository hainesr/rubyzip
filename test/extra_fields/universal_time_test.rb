# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/extra_fields/universal_time'

class UniversalTimeTest < Minitest::Test
  PARSE_TESTS = [
    ["\x01PS>A", true, true, false],
    ["\x02PS>A", false, true, true],
    ["\x04PS>A", true, false, true],
    ["\x03PS>APS>A", false, true, false],
    ["\x05PS>APS>A", true, false, false],
    ["\x06PS>APS>A", false, false, true],
    ["\x07PS>APS>APS>A", false, false, false]
  ].freeze

  def test_parse
    PARSE_TESTS.each do |bin, a, c, m|
      ut = Rubyzip::ExtraFields::UniversalTime.new(bin)

      assert_equal(a, ut.atime.nil?)
      assert_equal(c, ut.ctime.nil?)
      assert_equal(m, ut.mtime.nil?)
    end
  end

  def test_times
    time = Time.utc(2004, 9, 8, 0, 33, 20)
    ut = Rubyzip::ExtraFields::UniversalTime.new("\x03PS>APS>A")

    assert_equal(time, ut.atime)
    assert_nil(ut.ctime)
    assert_equal(time, ut.mtime)
  end

  def test_id
    data = "\x01PS>A"
    ut = Rubyzip::ExtraFields::UniversalTime.new(data)

    assert_equal('UT', ut.id)
  end

  def test_label
    assert_equal('UniversalTime', Rubyzip::ExtraFields::UniversalTime.label)
  end
end
