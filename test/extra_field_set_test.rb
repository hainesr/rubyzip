require 'test_helper'

class ZipExtraFieldSetTest < MiniTest::Test
  def test_new
    null = ::Zip::ExtraFieldSet.new
    empty = ::Zip::ExtraFieldSet.new('')
    nonsense = ::Zip::ExtraFieldSet.new('xxxx')

    assert_instance_of(::Zip::ExtraFieldSet, null)
    assert_equal(0, null.size)

    assert_instance_of(::Zip::ExtraFieldSet, empty)
    assert_equal(0, empty.size)

    assert_instance_of(::Zip::ExtraFieldSet, nonsense)
    assert_equal(0, nonsense.size)
    assert_nil(nonsense['xx'])

    assert_nil(empty['zip64'])
  end

  def test_unknown_fields
    xx_data = "XX\x05\x00hello".force_encoding('BINARY')
    xy_data = "XY\x05\x00world".force_encoding('BINARY')

    extra = ::Zip::ExtraFieldSet.new(xx_data)
    assert_equal(1, extra.length)
    refute_nil(extra['XX'])
    assert_instance_of(::Zip::ExtraFields::Unknown, extra['XX'])
    assert_equal(5, extra['XX'].local_size)
    assert_equal(5, extra['XX'].c_dir_size)
    assert_equal('hello', extra['XX'].to_local_bin)
    assert_equal('hello', extra['XX'].to_c_dir_bin)
    assert_equal(9, extra.local_size)
    assert_equal(9, extra.c_dir_size)
    assert_equal(xx_data, extra.to_local_bin)
    assert_equal(xx_data, extra.to_c_dir_bin)

    extra.merge(xy_data)
    assert_equal(2, extra.length)
    refute_nil(extra['XX'])
    refute_nil(extra['XY'])
    assert_instance_of(::Zip::ExtraFields::Unknown, extra['XY'])
    assert_equal(5, extra['XY'].local_size)
    assert_equal(5, extra['XY'].c_dir_size)
    assert_equal('world', extra['XY'].to_local_bin)
    assert_equal('world', extra['XY'].to_c_dir_bin)
    assert_equal(18, extra.local_size)
    assert_equal(18, extra.c_dir_size)
    assert_equal(xx_data + xy_data, extra.to_local_bin)
    assert_equal(xx_data + xy_data, extra.to_c_dir_bin)
  end
end
