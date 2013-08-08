# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yield/version'

Gem::Specification.new do |spec|
  spec.name          = "yield"
  spec.version       = Yield::VERSION
  spec.authors       = ["Casey Scarborough"]
  spec.email         = ["caseyscarborough@gmail.com"]
  spec.description   = %q{A utility for previewing markdown files in GitHub Flavored Markdown.}
  spec.summary       = %q{Yield is a command line utility written in Ruby that allows a user to render
    markdown files for previewing in a browser. It renders the markdown files using GitHub flavored 
    markdown at http://localhost:4000/ using Sinatra and Thin.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "sinatra", "1.4.3"
  spec.add_dependency "thin", "1.5.1"
  spec.add_dependency "launchy", "2.3.0"
end
