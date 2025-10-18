# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/version'

class VersionTest < Minitest::Test
  def test_version
    # Ensure all our versions numbers have at least MAJOR.MINOR.PATCH
    # elements separated by dots, to comply with Semantic Versioning.
    assert_match(/^\d+\.\d+\.\d+/, Rubyzip::VERSION)
  end
end
