# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

# Fixtures directories.
FIXTURES_DIR = ::File.expand_path('fixtures', __dir__)
BIN_FIXTURES = ::File.join(FIXTURES_DIR, 'bin')
ZIP_FIXTURES = ::File.join(FIXTURES_DIR, 'zip')

# Test zips.
ZIP_ONE_TEXT_FILE = ::File.join(ZIP_FIXTURES, 'one_text_file.zip')
ZIP_ONE_TEXT_FILE_STOR = ::File.join(ZIP_FIXTURES, 'one_text_file_stored.zip')
ZIP_ONE_DIRECTORY = ::File.join(ZIP_FIXTURES, 'one_directory.zip')

# Test binary data.
BIN_LOCAL_HEADER = ::File.join(BIN_FIXTURES, 'local_header.bin')