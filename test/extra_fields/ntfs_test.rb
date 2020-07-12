require 'test_helper'

class ZipExtraFieldsNTFSTest < MiniTest::Test
  def test_parse
    str = "\x0A\x00 \x00\x00\x00\x00\x00\x01\x00\x18\x00" \
    "\xC0\x81\x17\xE8B\xCE\xCF\x01\xC0\x81\x17\xE8B\xCE\xCF\x01" \
    "\xC0\x81\x17\xE8B\xCE\xCF\x01".force_encoding('BINARY')

    ntfs = ::Zip::ExtraFields::NTFS.new(str)

    t = ::Zip::DOSTime.at(1_410_496_497.405178)
    assert_equal(t, ntfs.mtime)
    assert_equal(t, ntfs.atime)
    assert_equal(t, ntfs.ctime)
  end

  def test_parse_nil
    ntfs = ::Zip::ExtraFields::NTFS.new
    assert_nil(ntfs.mtime)
    assert_nil(ntfs.atime)
    assert_nil(ntfs.ctime)
  end

  def test_init_through_extra_field_set
    ntfs_data = "\x0A\x00 \x00\x00\x00\x00\x00\x01\x00\x18\x00" \
      "\xC0\x81\x17\xE8B\xCE\xCF\x01\xC0\x81\x17\xE8B\xCE\xCF\x01" \
      "\xC0\x81\x17\xE8B\xCE\xCF\x01".force_encoding('BINARY')
    ntfs_payload = "\x00\x00\x00\x00\x01\x00\x18\x00" \
      "\xC0\x81\x17\xE8B\xCE\xCF\x01\xC0\x81\x17\xE8B\xCE\xCF\x01" \
      "\xC0\x81\x17\xE8B\xCE\xCF\x01".force_encoding('BINARY')
    extra = ::Zip::ExtraFieldSet.new(ntfs_data)

    refute_nil(extra["\x0A\x00"])
    assert_instance_of(::Zip::ExtraFields::NTFS, extra["\x0A\x00"])
    assert_equal(32, extra["\x0A\x00"].local_size)
    assert_equal(32, extra["\x0A\x00"].c_dir_size)
    assert_equal(ntfs_payload, extra["\x0A\x00"].to_local_bin)
    assert_equal(ntfs_payload, extra["\x0A\x00"].to_c_dir_bin)
    assert_equal(36, extra.local_size)
    assert_equal(36, extra.c_dir_size)
    assert_equal(ntfs_data, extra.to_local_bin)
    assert_equal(ntfs_data, extra.to_c_dir_bin)
  end
end
