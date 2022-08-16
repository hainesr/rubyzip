# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'

task default: :test

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

RuboCop::RakeTask.new
