# frozen_string_literal: true

require_relative 'test_helper'
require_relative 'helpers/decompressor_tests'

class InflaterTest < Minitest::Test
  include DecompressorTests

  # The maximum expansion ratio of the deflate algorithm is a little over
  # 1000:1 (1032:1), so this is the most that inflating one input chunk can
  # ever add to the buffer.
  MAX_DEFLATE_RATIO = 1032

  def setup
    super
    @file = File.new('test/data/file1.txt.deflatedData', 'rb')
    @decompressor = ::Zip::Inflater.new(@file)
  end

  def teardown
    @file.close
  end

  def test_buffer_is_bounded_when_reading_highly_compressible_data
    # 8 MiB of repeated XML deflates to under 32 KiB, so before the input
    # chunk size was bounded a single read inflated the whole entry into the
    # buffer (peak over 8 MiB); now the buffer is bounded by what a single
    # small input chunk can inflate to.
    row = '<row r="1"><c r="A1" t="s"><v>0</v></c><c r="B1"><v>12345</v></c></row>'
    data = (row * ((8 * 1024 * 1024 / row.bytesize) + 1)).b
    deflater = ::Zlib::Deflate.new(::Zlib::DEFAULT_COMPRESSION, -::Zlib::MAX_WBITS)
    compressed = deflater.deflate(data, ::Zlib::FINISH)
    deflater.close
    assert_operator(compressed.bytesize, :<, ::Zip::Decompressor::CHUNK_SIZE)

    inflater = ::Zip::Inflater.new(StringIO.new(compressed))
    read_length = 16_384
    bound = ::Zip::Inflater::INPUT_CHUNK_SIZE * MAX_DEFLATE_RATIO
    output = +''.b
    peak = 0
    while (chunk = inflater.read(read_length))
      output << chunk
      # The buffer has just had `read_length` bytes sliced off it, so this is
      # the excess inflated beyond what the caller asked for.
      remaining = inflater.instance_variable_get(:@buffer).bytesize
      peak = [peak, remaining + chunk.bytesize].max
      assert_operator(remaining, :<=, bound)
    end

    assert_equal(data, output)
    assert_operator(peak, :<=, bound + read_length)
    assert_operator(peak, :<, data.bytesize / 2)
  end
end
