# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

# Fixtures directories.
FIXTURES_DIR = File.expand_path('fixtures', __dir__)
BIN_FIXTURES = File.join(FIXTURES_DIR, 'bin')
TXT_FIXTURES = File.join(FIXTURES_DIR, 'text')
ZIP_FIXTURES = File.join(FIXTURES_DIR, 'zip')

# Test zips.
ZIP_ONE_TEXT_FILE = File.join(ZIP_FIXTURES, 'one_text_file.zip')
ZIP_ONE_TEXT_FILE_STOR = File.join(ZIP_FIXTURES, 'one_text_file_stored.zip')
ZIP_ONE_DIRECTORY = File.join(ZIP_FIXTURES, 'one_directory.zip')
ZIP_ONE_PNG_FILE = File.join(ZIP_FIXTURES, 'one_png_file.zip')

# Test binary data.
BIN_LOCAL_HEADER = File.join(BIN_FIXTURES, 'local_header.bin')
BIN_LOREM_IPSUM_DEFLATED = File.join(BIN_FIXTURES, 'lorem_ipsum_deflated.bin')
BIN_PNG_FILE = File.join(BIN_FIXTURES, 'zip.png')

# Test text data.
TXT_LOREM_IPSUM = File.join(TXT_FIXTURES, 'lorem_ipsum.txt')
