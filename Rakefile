# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'
require 'rubocop/rake_task'

task default: :test

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'LICENCE', 'lib/**/*.rb')
  rdoc.options << '--markup=markdown'
  rdoc.options << '--tab-width=2'
  rdoc.options << "-t Rubyzip version #{::Rubyzip::VERSION}"
end

RuboCop::RakeTask.new
