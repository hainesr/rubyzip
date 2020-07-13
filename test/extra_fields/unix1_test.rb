require 'test_helper'

class ZipExtraFieldsUnix1Test < MiniTest::Test
  def test_parse
    str = "\x9D\xA6\f_\x9D\xA6\f_\xE9\x03\xEA\x03".force_encoding('BINARY')
    ux = ::Zip::ExtraFields::Unix1.new(str)

    assert_equal(Zip::DOSTime.at(1594664605), ux.atime)
    assert_equal(Zip::DOSTime.at(1594664605), ux.mtime)
    assert_equal(1_002, ux.gid)
    assert_equal(1_001, ux.uid)
  end

  def test_parse_nil
    ux = ::Zip::ExtraFields::Unix1.new
    assert_nil(ux.atime)
    assert_nil(ux.mtime)
    assert_equal(0, ux.uid)
    assert_equal(0, ux.gid)
  end

  def test_init_through_extra_field_set
    ux_data = "UX\x0C\x00\x9D\xA6\f_\x9D\xA6\f_" \
      "\xE9\x03\xEA\x03".force_encoding('BINARY')
    ux_local_payload = "\x9D\xA6\f_\x9D\xA6\f_" \
      "\xE9\x03\xEA\x03".force_encoding('BINARY')
    ux_c_dir_payload = "\x9D\xA6\f_\x9D\xA6\f_".force_encoding('BINARY')

    extra = ::Zip::ExtraFieldSet.new(ux_data)

    refute_nil(extra['UX'])
    assert_instance_of(::Zip::ExtraFields::Unix1, extra['UX'])
    assert_equal(12, extra['UX'].local_size)
    assert_equal(8, extra['UX'].c_dir_size)
    assert_equal(ux_local_payload, extra['UX'].to_local_bin)
    assert_equal(ux_c_dir_payload, extra['UX'].to_c_dir_bin)
    assert_equal(16, extra.local_size)
    assert_equal(12, extra.c_dir_size)
    assert_equal(ux_data, extra.to_local_bin)
    assert_equal([0x5855, 8].pack('vv') + ux_c_dir_payload, extra.to_c_dir_bin)
  end
end
