# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'minitest/autorun'

require_relative 'fixtures'

Minitest::Test.make_my_diffs_pretty!

# Configure Rubyzip here without pulling in the entire library.
#
# Config fields are set to defaults, and can be overridden using Minitest
# stubbing, as follows:
#
# Rubyzip.stub :error_on_invalid_crc32, false do
#   <code under test with non-default config>
# end
module Rubyzip
  module_function

  def name_and_comment_encoding
    'UTF-8'
  end

  def error_on_invalid_crc32 # rubocop:disable Naming/PredicateMethod
    true
  end

  def error_on_invalid_entry_size # rubocop:disable Naming/PredicateMethod
    true
  end
end
