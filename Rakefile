# frozen_string_literal: true

# Copyright (c) 2002-2025, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require 'bundler/gem_tasks'
require 'minitest/test_task'
require 'rdoc/task'
require 'rubocop/rake_task'

require_relative 'lib/rubyzip/version'
require_relative 'lib/zip/version'

task default: 'test:rubyzip'

namespace :test do
  Minitest::TestTask.create(:rubyzip) do |test|
    test.framework = 'require "simplecov"'
    test.test_globs = 'test/rubyzip/**/*_test.rb'
  end

  Minitest::TestTask.create(:zip) do |test|
    test.framework = 'require "simplecov"'
    test.test_globs = 'test/zip/**/*_test.rb'
  end

  desc 'Run all tests'
  task all: ['test:rubyzip', 'test:zip']
end

namespace :rdoc do
  names = { rdoc: 'rubyzip', clobber_rdoc: 'rubyzip:clobber', rerdoc: 'rubyzip:rerdoc' }
  RDoc::Task.new(names) do |rdoc|
    rdoc.main = 'README.md'
    rdoc.rdoc_files.include('README.md', 'lib/rubyzip.rb', 'lib/rubyzip/**/*.rb')
    rdoc.rdoc_dir = 'html/rubyzip'
    rdoc.markup = 'markdown'
    rdoc.title = "Rubyzip version #{Rubyzip::VERSION}"
    rdoc.options << '--tab-width=2'
  end

  names = { rdoc: 'zip', clobber_rdoc: 'zip:clobber', rerdoc: 'zip:rerdoc' }
  RDoc::Task.new(names) do |rdoc|
    rdoc.main = 'README.md'
    rdoc.rdoc_files.include('README.md', 'lib/zip.rb', 'lib/zip/**/*.rb')
    rdoc.rdoc_dir = 'html/zip'
    rdoc.markup = 'markdown'
    rdoc.title = "Rubyzip version #{Zip::VERSION}"
    rdoc.options << '--tab-width=2'
  end
end

namespace :rubocop do
  common_patterns =
    ['benchmark/*.rb', 'bin/*', '.simplecov', 'Gemfile', 'Rakefile', 'rubyzip.gemspec']

  RuboCop::RakeTask.new(:rubyzip) do |rubocop|
    rubocop.patterns = common_patterns +
                       ['lib/rubyzip.rb', 'lib/rubyzip/**/*.rb', 'test/rubyzip/**/*.rb']
    rubocop.options = ['--config=.rubocop.rubyzip.yml']
  end

  RuboCop::RakeTask.new(:zip) do |rubocop|
    rubocop.patterns = common_patterns +
                       ['lib/zip.rb', 'lib/zip/**/*.rb', 'samples/zip/**/*.rb', 'test/zip/**/*.rb']
    rubocop.options = ['--config=.rubocop.zip.yml']
  end
end
