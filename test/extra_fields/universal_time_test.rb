require 'test_helper'

class ZipExtraFieldsUniversalTimeTest < MiniTest::Test
  PARSE_TESTS = [
    ["\x01PS>A", 0b001, true, true, false],
    ["\x02PS>A", 0b010, false, true, true],
    ["\x04PS>A", 0b100, true, false, true],
    ["\x03PS>APS>A", 0b011, false, true, false],
    ["\x05PS>APS>A", 0b101, true, false, false],
    ["\x06PS>APS>A", 0b110, false, false, true],
    ["\x07PS>APS>APS>A", 0b111, false, false, false]
  ]

  def test_parse
    PARSE_TESTS.each do |bin, flags, a, c, m|
      ut = ::Zip::ExtraFields::UniversalTime.new(bin)
      assert_equal(flags, ut.flag)
      assert(ut.atime.nil? == a)
      assert(ut.ctime.nil? == c)
      assert(ut.mtime.nil? == m)
    end
  end

  def test_parse_nil
    ut = ::Zip::ExtraFields::UniversalTime.new
    assert_equal(0b000, ut.flag)
    assert_nil(ut.atime)
    assert_nil(ut.ctime)
    assert_nil(ut.mtime)
  end

  def test_set_clear_times
    time = ::Zip::DOSTime.now
    ut = ::Zip::ExtraFields::UniversalTime.new
    assert_equal(0b000, ut.flag)

    ut.mtime = time
    assert_equal(0b001, ut.flag)
    assert_equal(time, ut.mtime)

    ut.ctime = time
    assert_equal(0b101, ut.flag)
    assert_equal(time, ut.ctime)

    ut.atime = time
    assert_equal(0b111, ut.flag)
    assert_equal(time, ut.atime)

    ut.ctime = nil
    assert_equal(0b011, ut.flag)
    assert_nil ut.ctime

    ut.mtime = nil
    assert_equal(0b010, ut.flag)
    assert_nil ut.mtime

    ut.atime = nil
    assert_equal(0b000, ut.flag)
    assert_nil ut.atime
  end

  def test_pack
    time = ::Zip::DOSTime.at('PS>A'.unpack1('l<'))
    ut = ::Zip::ExtraFields::UniversalTime.new
    assert_equal("\x00", ut.to_local_bin)
    assert_equal("\x00", ut.to_c_dir_bin)
    assert_equal(1, ut.local_size)
    assert_equal(1, ut.c_dir_size)

    ut.mtime = time
    assert_equal("\x01PS>A", ut.to_local_bin)
    assert_equal("\x01PS>A", ut.to_c_dir_bin)
    assert_equal(5, ut.local_size)
    assert_equal(5, ut.c_dir_size)

    ut.atime = time
    assert_equal("\x03PS>APS>A", ut.to_local_bin)
    assert_equal("\x03PS>A", ut.to_c_dir_bin)
    assert_equal(9, ut.local_size)
    assert_equal(5, ut.c_dir_size)

    ut.ctime = time
    assert_equal("\x07PS>APS>APS>A", ut.to_local_bin)
    assert_equal("\x07PS>A", ut.to_c_dir_bin)
    assert_equal(13, ut.local_size)
    assert_equal(5, ut.c_dir_size)
  end

  def test_init_through_extra_field_set
    ut_data = "UT\x0d\x00\x07PS>APS>APS>A"
    extra = ::Zip::ExtraFieldSet.new(ut_data)

    refute_nil(extra['UT'])
    assert_instance_of(::Zip::ExtraFields::UniversalTime, extra['UT'])
    assert_equal(13, extra['UT'].local_size)
    assert_equal(5, extra['UT'].c_dir_size)
    assert_equal("\x07PS>APS>APS>A", extra['UT'].to_local_bin)
    assert_equal("\x07PS>A", extra['UT'].to_c_dir_bin)
    assert_equal(17, extra.local_size)
    assert_equal(9, extra.c_dir_size)
    assert_equal(ut_data, extra.to_local_bin)
    assert_equal("UT\x05\x00\x07PS>A", extra.to_c_dir_bin)
  end
end
