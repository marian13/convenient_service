# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "bundler/setup"
require "convenient_service"
require "benchmark/ips"

class Service
  include ConvenientService::Standard::Config
end

Service.commit_config! # Warmup.

Benchmark.ips do |x|
  x.time = 10 # Seconds.
  x.warmup = 0 # No additional warmup required. It is already performed outside.

  x.report("`.commit_config?`") { Service.commit_config! }
end
