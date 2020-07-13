require 'test_helper'

class ZipExtraFieldsUnix2Test < MiniTest::Test
  def test_parse
    str = "\xE9\x03\xEA\x03".force_encoding('BINARY')
    ux = ::Zip::ExtraFields::Unix2.new(str)

    assert_equal(1_002, ux.gid)
    assert_equal(1_001, ux.uid)
  end

  def test_parse_nil
    ux = ::Zip::ExtraFields::Unix2.new
    assert_equal(0, ux.uid)
    assert_equal(0, ux.gid)
  end

  def test_init_through_extra_field_set
    ux_data = "Ux\x04\x00\xE9\x03\xEA\x03".force_encoding('BINARY')
    ux_payload = "\xE9\x03\xEA\x03".force_encoding('BINARY')

    extra = ::Zip::ExtraFieldSet.new(ux_data)

    refute_nil(extra['Ux'])
    assert_instance_of(::Zip::ExtraFields::Unix2, extra['Ux'])
    assert_equal(4, extra['Ux'].local_size)
    assert_equal(0, extra['Ux'].c_dir_size)
    assert_equal(ux_payload, extra['Ux'].to_local_bin)
    assert_equal('', extra['Ux'].to_c_dir_bin)
    assert_equal(8, extra.local_size)
    assert_equal(4, extra.c_dir_size)
    assert_equal(ux_data, extra.to_local_bin)
    assert_equal([0x7855, 0].pack('vv'), extra.to_c_dir_bin)
  end
end
