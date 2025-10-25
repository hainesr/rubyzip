# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/extra_fields/unix2'

class Unix2Test < Minitest::Test
  def setup
    data = "\xE9\x03\xEA\x03".b
    @ux = Rubyzip::ExtraFields::Unix2.new(data)
  end

  def test_uid
    assert_equal(1001, @ux.uid)
  end

  def test_gid
    assert_equal(1002, @ux.gid)
  end

  def test_id
    assert_equal('Ux', @ux.id)
  end

  def test_label
    assert_equal('Unix2', Rubyzip::ExtraFields::Unix2.label)
  end
end
