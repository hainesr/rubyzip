# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

source 'https://rubygems.org'

gemspec

group :benchmark do
  gem 'benchmark-memory', '~> 0.2'
  gem 'stackprof', '~> 0.2'
end

# TODO: remove when JRuby 9.4.10.0 will be released and available on CI
# Ref: https://github.com/jruby/jruby/issues/7262
if RUBY_PLATFORM.include?('java')
  gem 'jar-dependencies', '0.4.1'
  gem 'ruby-maven', '3.3.13'
end
