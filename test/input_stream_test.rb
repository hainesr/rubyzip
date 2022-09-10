# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'test_helper'

require 'rubyzip/input_stream'

class InputStreamTest < Minitest::Test
  def test_create_from_stream
    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      # Should not raise anything.
      Rubyzip::InputStream.new(zip)
    end
  end

  def test_open_from_stream
    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      # Should not raise anything.
      assert_instance_of(Rubyzip::InputStream, Rubyzip::InputStream.open(zip))
    end
  end

  def test_get_next_entry
    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)

      entry = zis.next_entry
      assert_instance_of(Rubyzip::Entry, entry)
      assert_equal('lorem_ipsum.txt', entry.name)
      assert_equal(
        Rubyzip::COMPRESSION_METHOD_DEFLATE,
        entry.compression_method
      )
    end
  end

  def test_next_entry_too_far
    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)

      entry = zis.next_entry
      assert_instance_of(Rubyzip::Entry, entry)
      assert_nil(zis.next_entry)
      assert_nil(zis.next_entry)
    end
  end

  def test_read_stored_entry
    text = ::File.read(TXT_LOREM_IPSUM)

    ::File.open(ZIP_ONE_TEXT_FILE_STOR, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)

      zis.next_entry
      contents = zis.read
      assert_equal(text, contents)
    end
  end

  def test_read_deflated_entry
    text = ::File.read(TXT_LOREM_IPSUM)

    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)

      zis.next_entry
      contents = zis.read
      assert_equal(text, contents)
    end
  end

  def test_read_directory_entry
    ::File.open(ZIP_ONE_DIRECTORY, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)
      entry = zis.next_entry

      assert_equal('directory/', entry.name)
      assert_predicate(entry, :directory?)
      assert_empty(zis.read)
    end
  end

  def test_read_binary_entry
    png = ::File.binread(BIN_PNG_FILE)

    ::File.open(ZIP_ONE_PNG_FILE, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)
      entry = zis.next_entry

      assert_equal('zip.png', entry.name)
      assert_equal(png, zis.read)
      assert_empty(zis.read)
    end
  end

  def test_partial_reads_from_entry
    text = ::File.read(TXT_LOREM_IPSUM)
    half_len = text.length / 2

    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      Rubyzip::InputStream.open(zip) do |zis|
        zis.next_entry
        assert_empty(zis.read(0))
        assert_equal(text[(0...half_len)], zis.read(half_len))
        assert_equal(text[(half_len...text.length)], zis.read)
      end
    end
  end

  def test_read_at_eof
    ::File.open(ZIP_ONE_TEXT_FILE, 'rb') do |zip|
      Rubyzip::InputStream.open(zip) do |zis|
        zis.next_entry
        zis.read

        assert_empty(zis.read)
        assert_empty(zis.read(0))
        assert_nil(zis.read(1))
      end
    end
  end

  def test_read_multiple_entries
    ::File.open(ZIP_MULTI_FILE, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)

      ['lorem_ipsum.txt', 'zip.png', 'one_level/lorem_ipsum.txt'].each do |name|
        entry = zis.next_entry
        assert_equal(name, entry.name)
      end
    end
  end

  def test_read_multiple_entries_via_block
    ::File.open(ZIP_MULTI_FILE, 'rb') do |zip|
      Rubyzip::InputStream.open(zip) do |zis|
        ['lorem_ipsum.txt', 'zip.png', 'one_level/lorem_ipsum.txt'].each do |name|
          entry = zis.next_entry
          assert_equal(name, entry.name)
        end
      end

      # The underlying stream used by InputStream should not be closed here.
      refute_predicate(zip, :closed?)
    end
  end

  def test_read_encrypted_stored_entry
    text = ::File.read(TXT_LOREM_IPSUM)

    ::File.open(ZIP_ENC_ONE_TEXT_FILE_STOR, 'rb') do |zip|
      zis = Rubyzip::InputStream.new(zip)

      zis.next_entry(password: 'Rubyz1p!')
      contents = zis.read
      assert_equal(text, contents)
    end
  end
end
