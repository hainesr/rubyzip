# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

##
module Rubyzip
  # This module provides configuration for Rubyzip. Configuration is
  # accessed through Rubyzip, as follows:
  #
  # ```
  # Rubyzip.error_on_invalid_crc32 = true
  # ```
  #
  # Or:
  #
  # ```
  # Rubyzip.configure do |config|
  #   config.error_on_invalid_crc32 = true
  # end
  # ```
  module Configuration
    # Configure whether we validate CRC-32 checksums when reading entries.
    #
    # Default: `true`.
    attr_accessor :error_on_invalid_crc32

    # Configure whether we validate extracted size when reading entries.
    #
    # Default: `true`.
    attr_accessor :error_on_invalid_entry_size

    # Configure which encoding we will use when reading entry names and
    # comments within Zip archives. According to the Zip standard this
    # value should only ever need to be `'IBM437'` (IBM Code Page 437) or
    # `'UTF-8'`. In practice, a lot of Zip tools use whatever character
    # encoding is set as the default for the OS on which they are running,
    # which can cause problems when trying to read entry names and comments.
    # This setting allows Rubyzip to interpret names and comments in any
    # character encoding that Ruby supports. In the vast majority of cases
    # this setting should be left alone, but if you know what encoding a Zip
    # archive has been created with, you can set this to match.
    #
    # This setting is overriden if an entry declares that it uses UTF-8
    # encoding within its header data. In this case UTF-8 is assumed.
    #
    # Default: `'UTF-8'`
    attr_accessor :name_and_comment_encoding

    # Configure whether we print a warning, or not, if we detect an invalid
    # date/time in a Zip archive. In either case the invalid date/time is
    # ignored and processing of the Zip archive will continue.
    #
    # Default: `true`
    attr_accessor :warn_on_invalid_date

    # :call-seq:
    #   reset!
    #
    # Return all configurable aspects of Rubyzip to their defaults.
    def reset!
      @__configured = false

      @error_on_invalid_crc32 = true
      @error_on_invalid_entry_size = true
      @name_and_comment_encoding = 'UTF-8'
      @warn_on_invalid_date = true
    end

    # :call-seq:
    #   configure { |config| ... }
    #
    # Yield this configuration so that multiple fields can be configured
    # at once.
    def configure
      yield self unless @__configured
      @__configured = true
    end
  end
end
