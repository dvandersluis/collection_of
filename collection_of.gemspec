lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collection_of/version'

Gem::Specification.new do |spec|
  spec.name          = 'collection_of'
  spec.version       = CollectionOf::VERSION
  spec.authors       = ['Daniel Vandersluis']
  spec.email         = ['dvandersluis@selfmgmt.com']
  spec.description   = 'Ruby object for ease of collecting a certain type'
  spec.summary       = 'Allows a collection of a given type of object to be worked with easily'
  spec.homepage      = 'https://github.com/dvandersluis/collection_of'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w[lib]

  spec.add_dependency 'activesupport', '>= 3.0.0'
  spec.add_development_dependency 'benchmark-ips'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rubocop'
end
