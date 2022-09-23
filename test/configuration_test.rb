# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/configuration'

class ConfigurationTest < Minitest::Test
  class TestRubyzip
    extend Rubyzip::Configuration
    reset!
  end

  def setup
    TestRubyzip.reset!
  end

  def test_config
    TestRubyzip.error_on_invalid_crc32 = false
    TestRubyzip.error_on_invalid_entry_size = false

    refute(TestRubyzip.error_on_invalid_crc32)
    refute(TestRubyzip.error_on_invalid_entry_size)
  end

  def test_config_with_block
    TestRubyzip.configure do |config|
      config.error_on_invalid_crc32 = false
      config.error_on_invalid_entry_size = false
    end

    refute(TestRubyzip.error_on_invalid_crc32)
    refute(TestRubyzip.error_on_invalid_entry_size)
  end

  def test_re_config_with_block
    # Dummy config.
    TestRubyzip.configure do |config|
      config
    end

    # Test that configuration can't be changed before reset!
    TestRubyzip.configure do |config|
      config.error_on_invalid_crc32 = false
    end
    assert(TestRubyzip.error_on_invalid_crc32)

    # Test that configuration can be changed after reset!
    TestRubyzip.reset!
    TestRubyzip.configure do |config|
      config.error_on_invalid_crc32 = false
    end
    refute(TestRubyzip.error_on_invalid_crc32)
  end
end
