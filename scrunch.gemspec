# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "scrunch/version"

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = "scrunch"
  spec.version       = Scrunch::VERSION
  spec.authors       = ["Geoff MacIntosh"]
  spec.email         = ["geoff@mac.into.sh"]

  spec.executables   = ["scrunch"]

  spec.summary       = "Squish audiobooks with force"
  spec.description   = "A tool to make audiobooks smaller"
  spec.homepage      = "https://github.com/geoffmacintosh/scrunch"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.46.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc", ">= 0.6.0"
  spec.add_development_dependency "method_source", ">= 0.8.2"
end
# rubocop:enable Metrics/BlockLength
