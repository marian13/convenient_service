# frozen_string_literal: true

require_relative "lib/convenient_service/specification"
require_relative "lib/convenient_service/version"

Gem::Specification.new do |spec|
  spec.name = ConvenientService::Specification::NAME
  spec.authors = ConvenientService::Specification::AUTHORS
  spec.email = ConvenientService::Specification::EMAIL
  spec.homepage = ConvenientService::Specification::HOMEPAGE
  spec.summary = ConvenientService::Specification::SUMMARY
  spec.description = ConvenientService::Specification::DESCRIPTION

  spec.version = ConvenientService::VERSION

  spec.license = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]

  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "byebug", "~> 10.0"
  spec.add_development_dependency "commonmarker"
  spec.add_development_dependency "gem-release"
  spec.add_development_dependency "inch"
  spec.add_development_dependency "json"
  spec.add_development_dependency "paint"
  spec.add_development_dependency "progressbar"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rerun"
  spec.add_development_dependency "rouge"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "tty-prompt"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-lcov"
  spec.add_development_dependency "webrick"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "yard-junk"
end
