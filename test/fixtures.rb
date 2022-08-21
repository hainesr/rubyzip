# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

# Fixtures directories.
FIXTURES_DIR = ::File.expand_path('fixtures', __dir__)
ZIP_FIXTURES = ::File.join(FIXTURES_DIR, 'zip')

# Test zipz.
ZIP_ONE_TEXT_FILE = ::File.join(ZIP_FIXTURES, 'one_text_file.zip')
