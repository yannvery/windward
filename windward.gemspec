# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'windward/version'

Gem::Specification.new do |spec|
  spec.name          = "windward"
  spec.version       = Windward::VERSION
  spec.authors       = ["Yann VERY"]
  spec.email         = ["yann.very@gmail.com"]
  spec.description   = %q{Windward is a parser for meteofrance.fr\n You can retrieve informations like weather, temperature for each region of France.}
  spec.summary       = %q{A parser for meteofrance.fr}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency 'mechanize','>= 2.7.3'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
