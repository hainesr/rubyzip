# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/entry'

class EntryTest < Minitest::Test
  def test_create_with_name
    name = 'Entry_name.txt'
    entry = Rubyzip::Entry.new(name)

    assert_equal(name, entry.name)
  end
end
