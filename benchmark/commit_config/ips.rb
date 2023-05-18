# frozen_string_literal: true

require "bundler/setup"
require "convenient_service"
require "benchmark/ips"

class CurrentImplementation
  include ConvenientService::Standard::Config
end

CurrentImplementation.commit_config! # Warmup.

Benchmark.ips do |x|
  x.time = 10 # Seconds.
  x.warmup = 0 # No additional warmup required. It is already performed outside.

  x.report("`.commit_config?`") { CurrentImplementation.commit_config! }
end
