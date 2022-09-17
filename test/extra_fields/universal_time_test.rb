# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/extra_fields/universal_time'

class UniversalTimeTest < Minitest::Test
  PARSE_TESTS = [
    ["\x01PS>A".b, true, true, false],
    ["\x02PS>A".b, false, true, true],
    ["\x04PS>A".b, true, false, true],
    ["\x03PS>APS>A".b, false, true, false],
    ["\x05PS>APS>A".b, true, false, false],
    ["\x06PS>APS>A".b, false, false, true],
    ["\x07PS>APS>APS>A".b, false, false, false]
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
    ut = Rubyzip::ExtraFields::UniversalTime.new("\x03PS>APS>A".b)

    assert_equal(time, ut.atime)
    assert_nil(ut.ctime)
    assert_equal(time, ut.mtime)
  end

  def test_id
    data = "\x01PS>A".b
    ut = Rubyzip::ExtraFields::UniversalTime.new(data)

    assert_equal('UT', ut.id)
  end

  def test_label
    assert_equal('UniversalTime', Rubyzip::ExtraFields::UniversalTime.label)
  end
end
