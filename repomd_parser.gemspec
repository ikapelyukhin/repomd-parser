
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "repomd_parser/version"

Gem::Specification.new do |spec|
  spec.name          = "repomd_parser"
  spec.version       = RepomdParser::VERSION
  spec.authors       = ["Ivan Kapelyukhin"]
  spec.email         = ["ikapelyukhin@suse.com"]

  spec.summary       = %q{RPM repository metadata (RepoMD) parser}
  spec.homepage      = "https://github.com/ikapelyukhin/repomd-parser"
  spec.license       = 'GPL-2.0-or-later'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }.reject { |f| f.match(%r{^\.}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'simplecov', '~> 0.16.1'

  spec.add_dependency 'nokogiri', '~> 1.8'
  spec.add_dependency 'zstd-ruby', '~> 1.3', '>= 1.3.5.0'
end
