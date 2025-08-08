# frozen_string_literal: true

# Rubyzip is a ruby module for reading and writing zip files.
#
# The main entry points are File, InputStream and OutputStream. For a
# file/directory interface in the style of the standard ruby ::File and
# ::Dir APIs then `require 'zip/filesystem'` and see FileSystem.
module Zip
end

require_relative 'zip/version'
require_relative 'zip/file'

# Copyright (C) 2002, 2003 Thomas Sondergaard
# rubyzip is free software; you can redistribute it and/or
# modify it under the terms of the ruby license.
