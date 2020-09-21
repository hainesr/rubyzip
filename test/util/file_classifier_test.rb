# frozen_string_literal: true

require 'test_helper'
require 'zip/util/file_classifier'

class FileClassifierTest < MiniTest::Test
  def test_classify_data
    assert(::Zip::Util::FileClassifier.text?('Hello, World!'))
    assert(::Zip::Util::FileClassifier.binary?(''))
    assert(::Zip::Util::FileClassifier.binary?("\x00"))
    assert(::Zip::Util::FileClassifier.binary?("\x1b\x00"))
    assert(::Zip::Util::FileClassifier.binary?("\x1b"))
    assert(::Zip::Util::FileClassifier.text?("Hello, World\x21"))
    assert(::Zip::Util::FileClassifier.binary?("Hello, World\x00"))
    assert(::Zip::Util::FileClassifier.text?("Hello, World\x1b"))
    assert(::Zip::Util::FileClassifier.text?("\xab"))
  end

  def test_detect_text_file
    data = ::File.read('test/data/file1.txt')
    assert_equal(:text, ::Zip::Util::FileClassifier.classify(data))
    assert_equal(
      :text, ::Zip::Util::FileClassifier.classify(data, length: 2_048)
    )
    refute(::Zip::Util::FileClassifier.binary?(data))
    assert(::Zip::Util::FileClassifier.text?(data))
  end

  def test_detect_binary_file
    data = ::File.binread('test/data/test.xls', 256)
    assert_equal(:binary, ::Zip::Util::FileClassifier.classify(data))
    assert_equal(
      :binary, ::Zip::Util::FileClassifier.classify(data, length: 64)
    )
    assert(::Zip::Util::FileClassifier.binary?(data))
    refute(::Zip::Util::FileClassifier.text?(data))
  end
end
