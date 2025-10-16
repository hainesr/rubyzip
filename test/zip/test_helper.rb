# frozen_string_literal: true

require 'minitest/autorun'
require 'zip'

require_relative 'gentestfiles'

TestFiles.create_test_files
TestZipFile.create_test_zips

Minitest.after_run do
  FileUtils.rm_rf('test/zip/data/generated')
end

Minitest::Test.make_my_diffs_pretty!
