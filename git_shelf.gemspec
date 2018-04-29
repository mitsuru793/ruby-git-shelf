
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "git_shelf/version"

Gem::Specification.new do |spec|
  spec.name          = "git_shelf"
  spec.version       = GitShelf::VERSION
  spec.authors       = ["mitsuru793"]
  spec.email         = ["mitsuru793@gmail.com"]

  spec.summary       = %q{Git repository manager for code reading.}
  spec.description   = %q{Git repository manager for code reading.}
  spec.homepage      = "https://github.com/mitsuru793/ruby-git-shelf"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
