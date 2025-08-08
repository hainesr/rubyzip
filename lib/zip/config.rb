# frozen_string_literal: true

require 'zlib'

##
module Zip
  extend self

  attr_accessor :unicode_names,
                :on_exists_proc,
                :continue_on_exists_proc,
                :sort_entries,
                :default_compression,
                :write_zip64_support,
                :warn_invalid_date,
                :case_insensitive_match,
                :force_entry_names_encoding,
                :validate_entry_sizes

  DEFAULT_RESTORE_OPTIONS = {
    restore_ownership:   false,
    restore_permissions: true,
    restore_times:       true
  }.freeze # :nodoc:

  # :nodoc:
  # Remove this when JRuby#3962 is fixed.
  ZLIB_FLUSHING_STRATEGY = defined?(JRUBY_VERSION) ? Zlib::SYNC_FLUSH : Zlib::NO_FLUSH

  def reset! # :nodoc:
    @_ran_once = false
    @unicode_names = false
    @on_exists_proc = false
    @continue_on_exists_proc = false
    @sort_entries = false
    @default_compression = Zlib::DEFAULT_COMPRESSION
    @write_zip64_support = true
    @warn_invalid_date = true
    @case_insensitive_match = false
    @force_entry_names_encoding = nil
    @validate_entry_sizes = true
  end

  # Set options for RubyZip in one block.
  def setup
    yield self unless @_ran_once
    @_ran_once = true
  end

  reset!
end
