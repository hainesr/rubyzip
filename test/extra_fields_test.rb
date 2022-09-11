# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/extra_fields'

class ExtraFieldsTest < Minitest::Test
  TEST_EXTRA_FIELD_ID_NOT_STORED = 'ZZ'
  TEST_EXTRA_FIELD_ID = 'QQ'

  # Fake extra field.
  class TestExtraField
    EXTRA_FIELD_ID = TEST_EXTRA_FIELD_ID
  end

  def setup
    Rubyzip::ExtraFields.register_extra_field_type(TestExtraField)
  end

  def test_register_non_extra_field_types
    Rubyzip::ExtraFields.register_extra_field_type(String)
    refute(Rubyzip::ExtraFields.instance_variable_get(:@field_types).value?(String))
  end

  def test_extra_field_type_for
    assert_equal(
      TestExtraField,
      Rubyzip::ExtraFields.extra_field_type_for(TEST_EXTRA_FIELD_ID)
    )

    assert_nil(Rubyzip::ExtraFields.extra_field_type_for(TEST_EXTRA_FIELD_ID_NOT_STORED))
  end
end
