# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'semantic_versioning/version'

Gem::Specification.new do |spec|
  spec.name          = 'semantic_versioning'
  spec.version       = SemanticVersioning::VERSION
  spec.authors       = ['msfukui']
  spec.email         = ['msfukui@gmail.com']
  spec.summary       = 'Semantic versioning\'s class and command.'
  spec.description   = 'Semantic versioning\'s class and command \
  for setting, incrementing to major, minor, patch version label.'
  spec.homepage      = 'https://github.com/msfukui/semantic_versioning'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake',    '~> 10.3'
  spec.add_development_dependency 'rspec',   '~> 3.1'
end
