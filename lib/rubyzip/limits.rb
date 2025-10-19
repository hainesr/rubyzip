# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip # :nodoc:
  # Hard limits of the Zip archive format (without Zip64 extensions).
  # Notes:
  #  * Sizes are in bytes unless otherwise noted.
  #  * Name and comment sizes are in bytes too, not characters! This
  #    distinction matters for multibyte encodings such as UTF-8.
  LIMIT_NUM_ENTRIES             = 0xFFFF
  LIMIT_ENTRY_COMPRESSED_SIZE   = 0xFFFFFFFF
  LIMIT_ENTRY_UNCOMPRESSED_SIZE = 0xFFFFFFFF
  LIMIT_ENTRY_NAME_SIZE         = 0xFFFF
  LIMIT_ENTRY_COMMENT_SIZE      = 0xFFFF
  LIMIT_ARCHIVE_COMMENT_SIZE    = 0xFFFF
end
