# frozen_string_literal: true

require "bundler/setup"
require "convenient_service"
require "benchmark/ips"

##
# Introduction.
#
# This benchmark is checking `.has_committed_config?`. As a result, keep in mind that everything in this file should be reviewed in its context.
# For example, there is a class called `CurrentImplementation`. Actually, it is the `CurrentImplementationOfHasCommittedConfig`.
# Or `NoMemoization` - means `ImplementationWithNoMemoizationOfHasCommittedConfig`, etc.
#
# For the current implementation source, see `ConvenientService::Core::Concern::ClassMethods#has_committed_config?`.
##

class CurrentImplementation
  include ConvenientService::Standard::Config
end

class NoMemoization
  include ConvenientService::Standard::Config

  class << self
    def has_committed_config?
      (@__convenient_service_config__ ||= Entities::Config.new(klass: self)).committed?
    end
  end
end

class MemoizationInService
  include ConvenientService::Standard::Config

  class << self
    def has_committed_config?
      @__convenient_service_has_committed_config__ ||=
        (@__convenient_service_config__ ||= Entities::Config.new(klass: self)).committed?
    end
  end
end

class MemoizationInConfig
  include ConvenientService::Standard::Config

  (@__convenient_service_config__ ||= Entities::Config.new(klass: self)).define_singleton_method(:committed?) do
    @committed ||= concerns.included?
  end
end

class MemoizationInBoth
  include ConvenientService::Standard::Config

  class << self
    def has_committed_config?
      @__convenient_service_has_committed_config__ ||=
        (@__convenient_service_config__ ||= Entities::Config.new(klass: self)).committed?
    end
  end

  (@__convenient_service_config__ ||= Entities::Config.new(klass: self)).define_singleton_method(:committed?) do
    @committed ||= concerns.included?
  end
end

##
# Warmup.
#
implementations = [CurrentImplementation, NoMemoization, MemoizationInService, MemoizationInConfig, MemoizationInBoth]

5.times { implementations.each(&:commit_config!) }

##
# Benchmarking of iterations per second.
#
Benchmark.ips do |x|
  x.time = 5 # Seconds.
  x.warmup = 0 # No additional warmup required. It is already performed outside.

  x.report("`.has_committed_config?` - Current implementation") { CurrentImplementation.has_committed_config? }
  x.report("`.has_committed_config?` - No memoization") { NoMemoization.has_committed_config? }
  x.report("`.has_committed_config?` - Memoization in service") { MemoizationInService.has_committed_config? }
  x.report("`.has_committed_config?` - Memoization in config") { MemoizationInConfig.has_committed_config? }
  x.report("`.has_committed_config?` - Memoization in both") { MemoizationInBoth.has_committed_config? }

  x.compare!(order: :baseline)
end

##
# Example result.
#
# Calculating -------------------------------------
# `.has_committed_config?` - Current implementation
#                         116.854k (± 9.3%) i/s -    209.772k
# `.has_committed_config?` - No memoization
#                         117.368k (± 9.5%) i/s -    209.933k in   1.896137s
# `.has_committed_config?` - Memoization in service
#                         131.508k (± 9.1%) i/s -    219.171k in   1.769578s
# `.has_committed_config?` - Memoization in config
#                         127.826k (± 8.8%) i/s -    218.008k in   1.802826s
# `.has_committed_config?` - Memoization in both
#                         132.820k (± 9.0%) i/s -    221.383k in   1.766880s
#
# Comparison:
# `.has_committed_config?` - Current implementation:   116854.4 i/s
# `.has_committed_config?` - Memoization in both:   132819.7 i/s - same-ish: difference falls within error
# `.has_committed_config?` - Memoization in service:   131508.3 i/s - same-ish: difference falls within error
# `.has_committed_config?` - Memoization in config:   127825.8 i/s - same-ish: difference falls within error
# `.has_committed_config?` - No memoization:   117368.3 i/s - same-ish: difference falls within error
##

##
# Summary.
#
# It is one of the Convenient Service design goals to NOT pollute the end-user public interface with extra private methods, instance variables, etc.
# Since memoization does NOT bring too big performance improvement, no extra instance variables are introduced.
##

##
# More info.
# - https://johnnunemaker.com/how-to-benchmark-your-ruby-gem
# - https://github.com/evanphx/benchmark-ips
# - https://rubydoc.info/gems/benchmark-ips/Benchmark/Compare
# - https://en.wikipedia.org/wiki/Standard_deviation
##
