# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

# Fixtures directories.
FIXTURES_DIR = ::File.expand_path('fixtures', __dir__)
BIN_FIXTURES = ::File.join(FIXTURES_DIR, 'bin')
TXT_FIXTURES = ::File.join(FIXTURES_DIR, 'text')
ZIP_FIXTURES = ::File.join(FIXTURES_DIR, 'zip')

# Test zips.
ZIP_ONE_TEXT_FILE = ::File.join(ZIP_FIXTURES, 'one_text_file.zip')
ZIP_ONE_TEXT_FILE_STOR = ::File.join(ZIP_FIXTURES, 'one_text_file_stored.zip')
ZIP_ONE_DIRECTORY = ::File.join(ZIP_FIXTURES, 'one_directory.zip')
ZIP_ONE_PNG_FILE = ::File.join(ZIP_FIXTURES, 'one_png_file.zip')
ZIP_MULTI_FILE = ::File.join(ZIP_FIXTURES, 'multi_file.zip')
ZIP_MULTI_FILE_STREAMED = ::File.join(ZIP_FIXTURES, 'multi_file_streamed.zip')

ZIP_ENC_ONE_TEXT_FILE_STOR = ::File.join(ZIP_FIXTURES, 'one_text_file_stored_enc.zip')
ZIP_ENC_MULTI_FILE_STREAMED = ::File.join(ZIP_FIXTURES, 'multi_file_streamed_enc.zip')

ZIP64_SIMPLE = ::File.join(ZIP_FIXTURES, 'zip64_simple.zip')

# Test binary data.
BIN_LOCAL_HEADER = ::File.join(BIN_FIXTURES, 'local_header.bin')
BIN_LOCAL_HEADER_ZIP64 = ::File.join(BIN_FIXTURES, 'local_header_zip64.bin')
BIN_LOCAL_HEADER_NO_EXTRAS = ::File.join(BIN_FIXTURES, 'local_header_no_extras.bin')
BIN_LOCAL_HEADER_UT_NTFS = ::File.join(BIN_FIXTURES, 'local_header_ut_ntfs.bin')
BIN_LOCAL_HEADER_UTF8_GP = ::File.join(BIN_FIXTURES, 'local_header_utf8_gp.bin')
BIN_LOCAL_HEADER_UTF8_NOGP = ::File.join(BIN_FIXTURES, 'local_header_utf8_nogp.bin')

BIN_CDIR_END_RECORD = ::File.join(BIN_FIXTURES, 'cdir_end_record.bin')
BIN_CDIR_END_RECORD_ZIP64 = ::File.join(BIN_FIXTURES, 'cdir_end_record_zip64.bin')

BIN_LOREM_IPSUM_DEFLATED = ::File.join(BIN_FIXTURES, 'lorem_ipsum_deflated.bin')
BIN_LOREM_IPSUM_ENC = ::File.join(BIN_FIXTURES, 'lorem_ipsum_enc.bin')
BIN_PNG_FILE = ::File.join(BIN_FIXTURES, 'zip.png')

# Test text data.
TXT_LOREM_IPSUM = ::File.join(TXT_FIXTURES, 'lorem_ipsum.txt')
