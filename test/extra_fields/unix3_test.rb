# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative '../test_helper'

require 'rubyzip/extra_fields/unix3'

class Unix3Test < Minitest::Test
  def setup
    data = "\x01\x04\xF6\x01\x00\x00\x04\x14\x00\x00\x00"
    @ux = Rubyzip::ExtraFields::Unix3.new(data)
  end

  def test_version
    assert_equal(1, @ux.version)
  end

  def test_uid
    assert_equal(502, @ux.uid)
  end

  def test_gid
    assert_equal(20, @ux.gid)
  end

  def test_id
    assert_equal('ux', @ux.id)
  end

  def test_label
    assert_equal('Unix3', Rubyzip::ExtraFields::Unix3.label)
  end
end
