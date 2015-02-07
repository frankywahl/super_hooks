# -*- encoding: utf-8 -*-

require File.expand_path('../lib/super_hooks/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'super_hooks'
  gem.version       = SuperHooks::VERSION
  gem.summary       = %q{Handle git hooks across your system}
  gem.description   = %q{This allows you to have hooks at a User, Project or Global level}
  gem.license       = 'MIT'
  gem.authors       = ['Franky W.']
  gem.email         = 'frankywahl@users.noreply.github.com'
  gem.homepage      = 'https://rubygems.org/gems/super_hooks'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = ">= 2.0"

  gem.add_development_dependency 'codeclimate-test-reporter'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
end
