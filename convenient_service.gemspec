# frozen_string_literal: true

require_relative "lib/convenient_service/specification"
require_relative "lib/convenient_service/version"
require_relative "lib/convenient_service/dependencies/only_queries"

Gem::Specification.new do |spec|
  spec.name = ConvenientService::Specification::NAME
  spec.authors = ConvenientService::Specification::AUTHORS
  spec.email = ConvenientService::Specification::EMAIL
  spec.homepage = ConvenientService::Specification::HOMEPAGE
  spec.summary = ConvenientService::Specification::SUMMARY
  spec.description = ConvenientService::Specification::DESCRIPTION

  spec.version = ConvenientService::VERSION

  ##
  # Sets licence. See also `LICENSE.txt` and `COMM-LICENSE.txt` for more details.
  #
  # - https://guides.rubygems.org/specification-reference/#license=
  # - https://github.com/sidekiq/sidekiq/blob/main/sidekiq.gemspec
  # - https://github.com/rmosolgo/graphql-ruby/blob/master/graphql.gemspec
  # - https://github.com/thbar/kiba/blob/master/kiba.gemspec
  # - https://github.com/mbj/mutant/blob/main/mutant.gemspec
  # - https://github.com/github/licensed/tree/main?tab=readme-ov-file#disclaimer
  # - https://github.com/sergey-alekseev/bundler-licensed
  #
  spec.license = "LGPL-3.0"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  ##
  # Includes the minimal possible amount of files to the bundled Convenient Service version.
  #
  # NOTE: At the moment of writing this comment, Convenient Service weighed 170+ MB.
  # That was a problem in the space limited environments.
  #
  # NOTE: If you would like to play with Convenient Service specs, consider to `git clone` the gem.
  # - https://github.com/marian13/convenient_service
  #
  # NOTE: More thoughts on what should be included in the production version of a gem.
  # - https://github.com/rubocop/rubocop/blob/v1.60.1/rubocop.gemspec
  # - https://github.com/rails/rails/blob/v7.1.3/activerecord/activerecord.gemspec#L20
  # - https://github.com/mvz/gir_ffi/blob/master/gir_ffi.gemspec#L27
  # - https://github.com/payolapayments/payola/issues/292
  # - https://github.com/rubocop/rubocop/issues/1555
  #
  spec.files = ::Dir["COMM-LICENSE.txt", "LICENSE.txt", "README.md", "lib/**/*"] - ::Dir["lib/convenient_service/examples/**/*"] - ::Dir["lib/convenient_service/debug/**/*"]

  spec.require_paths = ["lib"]

  ##
  # NOTE: Dependencies must be kept in sync with `lib/convenient_service/dependencies/built_in.rb`.
  ##

  ##
  # Used for delegation.
  # - https://github.com/ruby/delegate
  #
  # spec.add_dependency "delegate"

  ##
  # Used for logging of the most critical Convenient Service parts, like config auto commitment.
  # - https://github.com/ruby/logger
  #
  # Starting from Ruby 4.0, the `logger` is NO longer bundled with the stdlib.
  # - https://github.com/sidekiq/sidekiq/pull/6320
  #
  # NOTE: Ruby 3.4 prints the warning below.
  #   warning: logger was loaded from the standard library, but will no longer be part of the default gems starting from Ruby 4.0.0.
  #
  spec.add_dependency "logger" if ConvenientService::Dependencies.ruby >= 3.4

  ##
  # Used for `ConvenientService.root`.
  # - https://github.com/ruby/pathname
  #
  # spec.add_dependency "pathname"

  ##
  # Used by step aware enumerables.
  # - https://github.com/ruby/set
  #
  # Starting from Ruby 4.0, `Set` is a core class.
  # - https://www.ruby-lang.org/en/news/2025/12/18/ruby-4-0-0-preview3-released
  #
  # spec.add_dependency "set"

  ##
  # Used for single logger instance.
  # - https://github.com/ruby/singleton
  #
  # spec.add_dependency "singleton"

  ##
  # Used by stubs.
  # - https://github.com/ruby/ruby/blob/master/thread.c
  #
  # spec.add_dependency "thread"
end
