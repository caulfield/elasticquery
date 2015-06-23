# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticquery/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticquery"
  spec.version       = Elasticquery::VERSION
  spec.authors       = ["Sergey Kuchmistov"]
  spec.email         = ["sergey.kuchmistov@gmail.com"]
  spec.summary       = %q{Elasticsearch query builder.}
  spec.description   = %q{Powerful and flexible elasticsearch query factory for you ruby application}
  spec.homepage      = "https://github.com/caulfield/elasticquery"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "elasticsearch-model"
end
