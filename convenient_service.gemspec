# frozen_string_literal: true

require_relative "lib/convenient_service/specification"
require_relative "lib/convenient_service/version"

##
# NOTE:
#   - Use `ConvenientService::Support::Ruby.jruby?` directly only in the files that do not require to load all dependencies.
#   - Prefer `ConvenientService::Dependencies.ruby.jruby?` for the rest of the files.
#
require_relative "lib/convenient_service/support/ruby"

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

  ##
  # Used to run specs with multiple versions of gems.
  # - https://github.com/thoughtbot/appraisal
  #
  spec.add_development_dependency "appraisal", "~> 2.5.0"

  spec.add_development_dependency "awesome_print"

  ##
  # Used for benchmarking (iteration per second). See `benchmark` directory.
  # - https://github.com/evanphx/benchmark-ips
  # - https://www.johnnunemaker.com/how-to-benchmark-your-ruby-gem
  #
  spec.add_development_dependency "benchmark-ips", "~> 2.12.0"

  ##
  # Used for debugging any Ruby code (CRuby, JRuby, etc), since it written in plain Ruby.
  # Has minimalistic interface.
  # Does NOT support frame filtering.
  # - https://github.com/gsamokovarov/break
  #
  spec.add_development_dependency "break"

  ##
  # Used for debugging CRuby code.
  # Check `debug` if you need frame filtering.
  # Check `break` if you need to debug JRuby.
  # - https://github.com/deivid-rodriguez/byebug
  #
  # NOTE: `byebug` has C extensions, that is why it is NOT supported in JRuby.
  # - https://github.com/deivid-rodriguez/byebug/tree/master/ext/byebug
  # - https://github.com/deivid-rodriguez/byebug/issues/179#issuecomment-152727003
  #
  spec.add_development_dependency "byebug", "~> 10.0" unless ConvenientService::Support::Ruby.jruby?

  ##
  # Used for parsing Markdown in YARD docs.
  # - https://github.com/gjtorikian/commonmarker
  #
  # NOTE: `commonmarker` has C extensions, that is why it is NOT supported in JRuby.
  # - https://github.com/gjtorikian/commonmarker/tree/main/ext/commonmarker
  #
  # TODO: `commonmarker` v1 does NOT work with `yard-junk`.
  #
  spec.add_development_dependency "commonmarker", "~> 0.23.10" unless ConvenientService::Support::Ruby.jruby?

  ##
  # Used for debugging CRuby code.
  # Has almost the same public API as `byebug`, but supports frame filtering.
  # Check `break` if you need to debug JRuby.
  # - https://github.com/ruby/debug
  # - https://st0012.dev/from-byebug-to-ruby-debug
  # - https://st0012.dev/from-byebug-to-ruby-debug#heading-configuration
  # - https://github.com/ruby/debug#configuration
  # - ENV["RUBY_DEBUG_SKIP_PATH"]
  #
  # NOTE: `debug` has C extensions, that is why it is NOT supported in JRuby.
  # - https://github.com/ruby/debug/tree/master/ext/debug
  #
  spec.add_development_dependency "debug" unless ConvenientService::Support::Ruby.jruby?

  spec.add_development_dependency "faker"

  spec.add_development_dependency "gem-release"

  spec.add_development_dependency "inch"

  spec.add_development_dependency "json"

  ##
  # Used for memory profiling of Ruby code.
  # - https://github.com/SamSaffron/memory_profiler
  # - https://thoughtbot.com/blog/a-crash-course-in-analyzing-memory-usage-in-ruby
  #
  spec.add_development_dependency "memory_profiler"

  ##
  # Used for testing Ruby code outside RSpec.
  # - https://github.com/minitest/minitest
  # - https://semaphoreci.com/community/tutorials/getting-started-with-minitest
  # - https://cloudbees.com/blog/getting-started-with-minitest
  #
  spec.add_development_dependency "minitest", "~> 5.18.0"

  ##
  # Used for mutation testing of Ruby code.
  # - https://github.com/mbj/mutant
  # - https://github.com/mbj/mutant/blob/main/docs/nomenclature.md
  # - https://github.com/mbj/mutant/blob/main/docs/mutant-rspec.md
  # - https://github.com/mbj/mutant/blob/main/docs/incremental.md
  #
  spec.add_development_dependency "mutant", "~> 0.11.21"
  spec.add_development_dependency "mutant-rspec", "~> 0.11.21"

  ##
  # Used for coloring logs.
  # - https://github.com/janlelis/paint
  #
  spec.add_development_dependency "paint"

  spec.add_development_dependency "progressbar"

  spec.add_development_dependency "rake", "~> 12.0"

  spec.add_development_dependency "rerun"

  spec.add_development_dependency "rouge"

  ##
  # Used for testing Ruby code.
  # https://rspec.info
  #
  spec.add_development_dependency "rspec", "~> 3.11.0"

  ##
  # Used for performance testing with RSpec.
  # https://github.com/piotrmurach
  #
  spec.add_development_dependency "rspec-benchmark", "~> 0.6.0"

  ##
  # Used for linting Ruby files.
  # https://github.com/rubocop/rubocop
  #
  spec.add_development_dependency "rubocop", "~> 1.52.0"

  ##
  # Used as a set of rules for rubocop for linting RSpec files.
  # https://github.com/rubocop/rubocop-rspec
  #
  spec.add_development_dependency "rubocop-rspec", "~> 2.22.0"

  spec.add_development_dependency "tty-prompt"

  ##
  # Used as a set of rules for robocop for linting source files.
  # https://github.com/testdouble/standard
  #
  spec.add_development_dependency "standard", "~> 1.30.1"

  spec.add_development_dependency "simplecov"

  spec.add_development_dependency "simplecov-lcov"

  ##
  # Used to have a simplified public API of minitest.
  # - https://github.com/thoughtbot/shoulda-context
  #
  spec.add_development_dependency "shoulda-context", "~> 2.0.0"

  ##
  # Used for benchmarking (call-stack profiler). See `benchmark` directory.
  # - https://github.com/tmm1/stackprof
  # - https://www.johnnunemaker.com/how-to-benchmark-your-ruby-gem
  #
  spec.add_development_dependency "stackprof", "~> 0.2.25" unless ConvenientService::Support::Ruby.jruby?

  spec.add_development_dependency "webrick"

  ##
  # Used for generation of API docs for Ruby code.
  # - https://github.com/lsegal/yard
  # - https://yardoc.org
  #
  spec.add_development_dependency "yard", "~> 0.9.34"

  ##
  # Used for linting YARD docs.
  # - https://github.com/zverok/yard-junk
  #
  spec.add_development_dependency "yard-junk", "~> 0.0.9"

  ##
  # The following gems are Convenient Service alternatives.
  # Used for performance comparisons.
  # See `benchmark/empty_service`.
  # - https://github.com/sunny/actor
  # - https://github.com/collectiveidea/interactor
  # - https://github.com/trailblazer/trailblazer-operation
  # - https://github.com/AaronLasseigne/active_interaction
  # - https://github.com/adomokos/light-service
  # - https://github.com/cypriss/mutations
  #
  spec.add_development_dependency "service_actor", "~> 3.7.0"
  spec.add_development_dependency "interactor", "~> 3.1.2"
  spec.add_development_dependency "trailblazer-operation", "~> 0.10.1"
  spec.add_development_dependency "active_interaction", "~> 5.3.0"
  spec.add_development_dependency "light-service", "~> 0.18.0"
  spec.add_development_dependency "mutations", "~> 0.9.1"
end
