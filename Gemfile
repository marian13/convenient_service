# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: Run the following commands any time you modify gemfile or gemspec.
#   task deps:clean
#   task docker:build:all
##

source "https://rubygems.org"

##
# NOTE: Should be placed before `gemspec`.
# - https://github.com/mbj/mutant/issues/1396
# - https://github.com/mbj/mutant/tree/a19e11a07e71a40cfa62636f7aea611e314de841#getting-an-opensource-license
# - https://github.com/mbj/auom/blob/master/Gemfile#L5
#
if ENV["CONVENIENT_SERVICE_MUTANT_LICENCE_KEY"]
  source "https://oss:#{ENV["CONVENIENT_SERVICE_MUTANT_LICENCE_KEY"]}@gem.mutant.dev" do
    gem "mutant-license"
  end
end

##
# NOTE: Specify gem's dependencies in `convenient_service.gemspec`.
# - https://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/
#
gemspec

##
# NOTE: Specify gem's dev dependencies in `Gemfile`.
# - https://github.com/sidekiq/sidekiq/blob/main/Gemfile
#
# NOTE: Dependabot can NOT use `require "convenient_service/dependencies/only_queries"`.
# NOTE: `require "convenient_service/dependencies/only_queries"` does NOT work inside `Gemfile`.
#
# rubocop:disable Packaging/RequireRelativeHardcodingLib
# require_relative "lib/convenient_service/dependencies/only_queries"
# rubocop:enable Packaging/RequireRelativeHardcodingLib
##

##
# Used for pretty printing when debugging Ruby code. `amazing_print` is `awesome_print` successor.
# - https://github.com/amazing-print/amazing_print
#
gem "amazing_print", "~> 1.5.0"

##
# Used to run specs with multiple versions of gems.
# - https://github.com/thoughtbot/appraisal
#
gem "appraisal", "~> 2.5.0"

##
# Used for pretty printing when debugging Ruby code. `awesome_print` is NOT maintained anymore.
# - https://github.com/awesome-print/awesome_print
#
gem "awesome_print", "~> 1.9.2"

##
# Used inside examples (internally by Active Model).
# - https://github.com/ruby/base64
#
gem "base64"

##
# Used for benchmarking. See `benchmark` directory.
# - https://github.com/ruby/benchmark
#
gem "benchmark", "~> 0.5.0"

##
# Used for benchmarking (iteration per second). See `benchmark` directory.
# - https://github.com/evanphx/benchmark-ips
# - https://www.johnnunemaker.com/how-to-benchmark-your-ruby-gem
#
gem "benchmark-ips", "~> 2.12.0"

##
# Used for benchmarking (memory allocation). See `benchmark` directory.
# - https://github.com/michaelherold/benchmark-memory
# - https://medium.com/swlh/benchmarking-in-ruby-86a6c28c1e97
# - https://thoughtbot.com/blog/a-crash-course-in-analyzing-memory-usage-in-ruby
#
gem "benchmark-memory", "~> 0.2.0"

##
# Used for debugging any Ruby code (CRuby, JRuby, etc), since it written in plain Ruby.
# Has minimalistic interface.
# Does NOT support frame filtering.
# - https://github.com/gsamokovarov/break
#
gem "break"

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
# NOTE: Keep in sync with `ConvenientService::Dependenies.support_byebug?`.
#
if RUBY_VERSION < "3.4"
  gem "byebug", "~> 10.0", platform: :mri
elsif RUBY_VERSION < "4.0"
  gem "byebug", "~> 12.0", platform: :mri
end

##
# Used for parsing Markdown in YARD docs.
# - https://github.com/gjtorikian/commonmarker
#
# NOTE: `commonmarker` has C extensions, that is why it is NOT supported in JRuby.
# - https://github.com/gjtorikian/commonmarker/tree/main/ext/commonmarker
#
# TODO: `commonmarker` v1 does NOT work with `yard-junk`.
#
gem "commonmarker", "~> 0.23.10", platform: :mri

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
gem "debug", platform: :mri

##
# Used for measing memory of `require "convenient_service"`.
# - https://github.com/zombocom/derailed_benchmarks
#
gem "derailed_benchmarks", "~> 2.1.2"

##
# Used for finding diffs between strings. Useful in console or specs.
# - https://github.com/samg/diffy
#
gem "diffy", "~> 3.4.0"

##
# Used for measing memory of `require "convenient_service"`.
# - https://github.com/zombocom/get_process_mem
#
gem "get_process_mem", "~> 0.2.7"

##
# Used to generate fake data.
#
gem "faker"

##
# Used internally by `rerun`.
#
gem "ffi", "~> 1.16.0"

##
# Used to release new Convenient Service versions.
#
gem "gem-release"

##
# Used as console/playground with loaded Convenient Service.
# - https://github.com/ruby/irb
#
gem "irb", "~> 1.16.0"

##
# Used to find missing documentation and to lint existing one.
# - https://github.com/rrrene/inch
#
gem "inch"

##
# Used inside examples.
# - https://github.com/ruby/json
#
gem "json"

##
# Used for memory profiling of Ruby code.
# - https://github.com/SamSaffron/memory_profiler
# - https://thoughtbot.com/blog/a-crash-course-in-analyzing-memory-usage-in-ruby
# - https://www.toptal.com/ruby/hunting-ruby-memory-issues
#
gem "memory_profiler"

##
# Used for testing Ruby code outside RSpec.
# - https://github.com/minitest/minitest
# - https://semaphoreci.com/community/tutorials/getting-started-with-minitest
# - https://cloudbees.com/blog/getting-started-with-minitest
#
gem "minitest", "~> 5.18.0"

##
# Used for mutation testing of Ruby code.
# - https://github.com/mbj/mutant
# - https://github.com/mbj/mutant/blob/main/docs/nomenclature.md
# - https://github.com/mbj/mutant/blob/main/docs/mutant-rspec.md
# - https://github.com/mbj/mutant/blob/main/docs/incremental.md
#
# NOTE: How to get a licence key?
# - https://github.com/mbj/mutant/issues/1396
#
if ::ENV["CONVENIENT_SERVICE_MUTANT_LICENCE_KEY"]
  gem "mutant", "~> 0.11.21"
  gem "mutant-rspec", "~> 0.11.21"
end

##
# Used inside examples (internally by Active Model).
# - https://github.com/ruby/mutex_m
#
gem "mutex_m"

##
# Used for coloring logs.
# - https://github.com/janlelis/paint
#
gem "paint"

##
# Used inside examples.
# - https://github.com/jfelchner/ruby-progressbar
#
gem "progressbar"

##
# Used as console/playground with loaded Convenient Service.
# - https://github.com/pry/pry
#
gem "pry", "~> 0.14.2"

##
# Used internally by Yard.
# - https://github.com/rack/rackup
# - https://github.com/lsegal/yard/blob/v0.9.37/lib/yard/server/rack_adapter.rb#L6
#
if RUBY_VERSION >= "3.4"
  gem "rackup", "~> 2.2.1"
end

##
# Used as Ruby task runner.
# - https://github.com/ruby/rake
#
gem "rake", "~> 12.3.3"

##
# Used to rerun specs on corresponding file change.
# - https://github.com/alexch/rerun
#
gem "rerun"

##
# Used to highlight syntax in `byebug` frames.
# - https://github.com/rouge-ruby/rouge
#
gem "rouge"

##
# Used for testing Ruby code.
# https://rspec.info
#
gem "rspec", "~> 3.11.0"

##
# Used for performance testing with RSpec.
# https://github.com/piotrmurach
#
gem "rspec-benchmark", "~> 0.6.0"

##
# Used for linting Ruby files.
# - https://github.com/rubocop/rubocop
#
gem "rubocop", "~> 1.61.0", platform: :mri

##
# Used as a set of rules for rubocop for linting common performance issues in Ruby files.
# - https://github.com/rubocop/rubocop-performance
#
# NOTE:
#   `rubocop-performance` is automatically bundled with Standard.
#    That is why it is NOT listed as a separate dependency for now.
#   Once the need for a specific version becomes mandatory, the following line should be uncommented
#
# gem "rubocop-performance"
##

##
# Used as a set of rules for rubocop for linting magic numbers in Ruby files.
# - https://github.com/rubocop/rubocop-magic_numbers
# - https://github.com/meetcleo/rubocop-magic_numbers
#
gem "rubocop-magic_numbers", "~> 0.4.0", platform: :mri

##
# Used as a set of rules for rubocop for linting RSpec files.
# - https://github.com/rubocop/rubocop-rspec
#
gem "rubocop-rspec", "~> 2.27.0", platform: :mri

##
# Used as a set of rules for rubocop for enforcing Ruby gem packaging best practices.
# - https://github.com/utkarsh2102/rubocop-packaging
#
gem "rubocop-packaging", "~> 0.5.2", platform: :mri

##
# Used as a set of rules for rubocop for linting common thread-safety issues in Ruby files.
# - https://github.com/rubocop/rubocop-thread_safety
#
gem "rubocop-thread_safety", "~> 0.5.1", platform: :mri

##
# Used for linting of Ruby files.
# TODO: Add `.rubycritic` config.
# - https://github.com/whitesmith/rubycritic
#
gem "rubycritic", platform: :mri

##
# Used for parsing console input.
# - https://github.com/piotrmurach/tty-prompt
#
gem "tty-prompt"

##
# Used as a set of rules for robocop for linting source files.
# - https://github.com/testdouble/standard
#
gem "standard", "~> 1.34.0", platform: :mri

##
# Used to calculate coverage of Ruby code.
# - https://github.com/simplecov-ruby/simplecov
#
gem "simplecov"

##
# Used to share and merge coverage info.
# - https://github.com/fortissimo1997/simplecov-lcov
#
gem "simplecov-lcov"

##
# Used to have a simplified(more RSpec-like) public API of minitest.
# - https://github.com/thoughtbot/shoulda-context
#
gem "shoulda-context", "~> 2.0.0"

##
# Used for benchmarking (call-stack profiler). See `benchmark` directory.
# - https://github.com/tmm1/stackprof
# - https://www.johnnunemaker.com/how-to-benchmark-your-ruby-gem
#
gem "stackprof", "~> 0.2.25", platform: :mri

##
# Used inside examples (internally by Webrick).
# - https://github.com/ruby/uri
#
if RUBY_VERSION >= "3.0"
  gem "uri", "~> 0.13.0"
else
  gem "uri", "0.10.0.2"
end

##
# Used inside examples.
# - https://github.com/ruby/webrick
#
gem "webrick", "~> 1.9.2"

##
# Used for generation of API docs for Ruby code.
# - https://github.com/lsegal/yard
# - https://yardoc.org
#
gem "yard", "~> 0.9.37"

##
# Used for linting YARD docs.
# - https://github.com/zverok/yard-junk
#
gem "yard-junk", "~> 0.0.10", platform: :mri

if ENV["CONVENIENT_SERVICE_BENCHMARK"]
  ##
  # The following gems are Convenient Service alternatives in some ways.
  # Used for performance comparisons.
  # See `benchmark/empty_service`.
  # - https://github.com/sunny/actor
  # - https://github.com/collectiveidea/interactor
  # - https://github.com/trailblazer/trailblazer-operation
  # - https://github.com/AaronLasseigne/active_interaction
  # - https://github.com/adomokos/light-service
  # - https://github.com/cypriss/mutations
  #
  gem "service_actor", "~> 3.7.0"
  gem "interactor", "~> 3.1.2"
  gem "trailblazer-operation", "~> 0.10.1"
  gem "active_interaction", "~> 5.5.0"
  gem "light-service", "~> 0.18.0"
  gem "mutations", "~> 0.9.1"
end
