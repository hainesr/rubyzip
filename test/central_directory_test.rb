# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/central_directory'

class CentralDirectoryTest < Minitest::Test
  def test_new
    ::File.open(BIN_CDIR_END_RECORD, 'rb') do |io|
      cdir = Rubyzip::CentralDirectory.new(io)

      assert_equal(2, cdir.size)
      assert_empty(cdir.comment)
    end
  end

  def test_new_max_comment
    ::File.open(ZIP_MAX_FILE_COMMENT, 'rb') do |io|
      cdir = Rubyzip::CentralDirectory.new(io)

      assert_equal(1, cdir.size)
      assert_equal(65_535, cdir.comment.bytesize)
    end
  end

  def test_new_max_comment_zip64
    ::File.open(ZIP64_MAX_FILE_COMMENT, 'rb') do |io|
      cdir = Rubyzip::CentralDirectory.new(io)

      assert_equal(2, cdir.size)
      assert_equal(65_535, cdir.comment.bytesize)
    end
  end
end
