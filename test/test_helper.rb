# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'

require_relative 'gentestfiles'

Minitest.after_run do
  FileUtils.rm_rf('test/data/generated')
end

Minitest::Test.make_my_diffs_pretty!

TestFiles.create_test_files
TestZipFile.create_test_zips
