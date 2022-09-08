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

  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "bundler-audit"
  spec.add_development_dependency "byebug", "~> 10.0"
  spec.add_development_dependency "inch"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rerun"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "sdoc"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-lcov"

  ##
  # TODO: Specs when a project does NOT use `activemodel' or `dry-initializer'.
  #
  # IMPORTANT: Implement fallbacks when the following libraries are NOT used.
  #
  spec.add_development_dependency "activemodel"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "dry-initializer"
  spec.add_development_dependency "dry-validation"
  spec.add_development_dependency "progressbar"
  spec.add_development_dependency "shoulda-matchers"
  spec.add_development_dependency "paint"
end
