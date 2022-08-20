# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/version'

class VersionTest < MiniTest::Test
  def test_version_exists
    assert(defined? Rubyzip::VERSION)
    assert_instance_of(String, Rubyzip::VERSION)
  end
end
