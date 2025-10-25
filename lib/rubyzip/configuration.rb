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
    # Default: `true`.
    attr_accessor :error_on_invalid_crc32

    # Configure whether we validate extracted size when reading entries.
    # Default: `true`.
    attr_accessor :error_on_invalid_entry_size

    # :call-seq:
    #   reset!
    #
    # Return all configurable aspects of Rubyzip to their defaults.
    def reset!
      @__configured = false

      @error_on_invalid_crc32 = true
      @error_on_invalid_entry_size = true
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
