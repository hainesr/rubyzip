# frozen_string_literal: true

# Copyright (c) 2002-2022, The Rubyzip Developers.
#
# Licensed under the BSD License. See LICENCE for details.

require_relative 'lib/rubyzip/version'

Gem::Specification.new do |s|
  s.name          = 'rubyzip'
  s.version       = ::Rubyzip::VERSION
  s.authors       = ['Robert Haines', 'John Lees-Miller', 'Alexander Simonov']
  s.email         = [
    'hainesr@gmail.com', 'jdleesmiller@gmail.com', 'alex@simonov.me'
  ]
  s.homepage      = 'http://github.com/rubyzip/rubyzip'
  s.platform      = Gem::Platform::RUBY
  s.summary       = 'Rubyzip is a ruby module for reading and writing zip files.'
  s.files         = Dir.glob('{samples,lib}/**/*.rb') +
                    %w[README.md Changelog.md Rakefile rubyzip.gemspec]
  s.require_paths = ['lib']
  s.license       = 'BSD-2-Clause'

  s.metadata      = {
    'bug_tracker_uri'       => 'https://github.com/rubyzip/rubyzip/issues',
    'changelog_uri'         => "https://github.com/rubyzip/rubyzip/blob/v#{s.version}/Changelog.md",
    'documentation_uri'     => "https://www.rubydoc.info/gems/rubyzip/#{s.version}",
    'source_code_uri'       => "https://github.com/rubyzip/rubyzip/tree/v#{s.version}",
    'wiki_uri'              => 'https://github.com/rubyzip/rubyzip/wiki',
    'rubygems_mfa_required' => 'true'
  }

  s.required_ruby_version = '>= 2.7'

  s.add_development_dependency 'minitest', '~> 5.16.0'
  s.add_development_dependency 'rake', '~> 13.0.0'
  s.add_development_dependency 'rdoc', '~> 6.4.0'
  s.add_development_dependency 'rubocop', '~> 1.35.0'
  s.add_development_dependency 'rubocop-minitest', '~> 0.21.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.14.0'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  s.add_development_dependency 'simplecov', '0.18.3'
  s.add_development_dependency 'simplecov-lcov', '~> 0.8'
end
