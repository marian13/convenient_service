# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

ENV["CONVENIENT_SERVICE_BENCHMARK"] = "true"

require "bundler/setup"

# require "convenient_service/dependencies/only_development_tools"
require "convenient_service"
require "benchmark/ips"

##
# Introduction.
#
# This benchmark is checking `.has_committed_config?`. As a result, keep in mind that everything in this file should be reviewed in its context.
# For example, there is a class called `CurrentImplementation`. Actually, it is the `ImplementationWithoutMemoizationOfHasCommittedConfigInService`.
# Or `WithMemoizationInService` - means `ImplementationWithMemoizationOfHasCommittedConfigInService`, etc.
#
# For the current implementation source, see `ConvenientService::Core::Concern::ClassMethods#has_committed_config?`.
##

class CurrentImplementation
  include ConvenientService::Standard::Config
end

class WithMemoizationInService
  include ConvenientService::Standard::Config

  class << self
    def has_committed_config?
      @__convenient_service_has_committed_config__ ||= super
    end
  end
end

##
# Warmup.
#
implementations = [CurrentImplementation, WithMemoizationInService]

implementations.each(&:commit_config!)

##
# Benchmarking of iterations per second.
#
Benchmark.ips do |x|
  x.time = 5 # Seconds.
  x.warmup = 0 # No additional warmup required. It is already performed outside.

  x.report("`.has_committed_config?` - No memoization in service") { CurrentImplementation.has_committed_config? }
  x.report("`.has_committed_config?` - Memoization in service") { WithMemoizationInService.has_committed_config? }

  x.compare!(order: :baseline)
end

##
# Example result.
#
# Calculating -------------------------------------
# `.has_committed_config?` - No memoization in service
#                         131.142k (± 8.9%) i/s -    220.039k in   1.777241s
# `.has_committed_config?` - Memoization in service
#                         131.319k (±10.5%) i/s -    216.215k in   1.763880s

# Comparison:
# `.has_committed_config?` - No memoization in service:   131142.1 i/s
# `.has_committed_config?` - Memoization in service:   131319.1 i/s - same-ish: difference falls within error
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
