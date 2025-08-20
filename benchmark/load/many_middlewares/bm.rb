# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "bundler/setup"

# require "convenient_service/dependencies/only_development_tools"
require "convenient_service"
require "benchmark"

ATTEMPTS = [
  {middlewares_count: 100},
  {middlewares_count: 1_000},
  {middlewares_count: 5_000},
  {middlewares_count: 10_000}
]

KLASSES = []

def build_service(middlewares_count)
  KLASSES <<
    Class.new.tap do |klass|
      klass.class_exec(middlewares_count) do |middlewares_count|
        include ConvenientService::Standard::Config

        1.upto(middlewares_count) do |index|
          middlewares :result do
            middleware = Class.new(ConvenientService::MethodChainMiddleware) do
              def next(...)
                chain.next(...)
              end
            end

            prepend middleware
          end
        end

        def result
          success
        end
      end
    end
end

def run_service(klass)
  result = klass.result

  if result.success?
    result.data
  else
    raise "Something went wrong..."
  end
end

Benchmark.bm(40) do |x|
  ATTEMPTS.each do |attempt|
    x.report("Build service with `#{attempt[:middlewares_count]}` middlewares") { build_service(attempt[:middlewares_count]) }
  end
end

Benchmark.bm(40) do |x|
  KLASSES.each do |klass|
    x.report("Run service with `#{klass.middlewares(:result).to_a.count { |middleware| middleware.name.nil? }}` middlewares") { run_service(klass) }
  end
end

##
# root@cc80940a7e23:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
#
# root@cc80940a7e23:/gem# ruby benchmark/load/many_middlewares/bm.rb
#                                                user     system      total        real
# Build service with `100` middlewares       0.007740   0.000000   0.007740 (  0.007743)
# Build service with `1000` middlewares      0.027957   0.000000   0.027957 (  0.027948)
# Build service with `5000` middlewares      0.078753   0.000000   0.078753 (  0.078923)
# Build service with `10000` middlewares     0.140936   0.000022   0.140958 (  0.141427)
#                                                user     system      total        real
# Run service with `100` middlewares         0.003678   0.000000   0.003678 (  0.003683)
# Run service with `1000` middlewares        0.009154   0.000000   0.009154 (  0.009153)
# Run service with `5000` middlewares      Traceback (most recent call last):
#         10079: from benchmark/load/many_middlewares/bm.rb:57:in `<main>'
#         10078: from /usr/local/lib/ruby/2.7.0/benchmark.rb:205:in `bm'
#         10077: from /usr/local/lib/ruby/2.7.0/benchmark.rb:173:in `benchmark'
#         10076: from benchmark/load/many_middlewares/bm.rb:58:in `block in <main>'
#         10075: from benchmark/load/many_middlewares/bm.rb:58:in `each'
#         10074: from benchmark/load/many_middlewares/bm.rb:59:in `block (2 levels) in <main>'
#         10073: from /usr/local/lib/ruby/2.7.0/benchmark.rb:375:in `item'
#         10072: from /usr/local/lib/ruby/2.7.0/benchmark.rb:293:in `measure'
#          ... 10067 levels...
#             4: from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/entities/method_chain.rb:47:in `next'
#             3: from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:58:in `call'
#             2: from benchmark/load/many_middlewares/bm.rb:26:in `next'
#             1: from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/entities/method_chain.rb:47:in `next'
# /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:45:in `call': stack level too deep (SystemStackError)
##

##
# root@f23f41addbe0:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
#
# root@f23f41addbe0:/gem# ruby benchmark/load/many_middlewares/bm.rb
#                                                user     system      total        real
# Build service with `100` middlewares       0.006849   0.000940   0.007789 (  0.007863)
# Build service with `1000` middlewares      0.023349   0.001147   0.024496 (  0.024660)
# Build service with `5000` middlewares      0.092517   0.000853   0.093370 (  0.093454)
# Build service with `10000` middlewares     0.173623   0.002951   0.176574 (  0.176830)
#                                                user     system      total        real
# Run service with `100` middlewares         0.003915   0.000000   0.003915 (  0.005017)
# Run service with `1000` middlewares        0.010530   0.000845   0.011375 (  0.011453)
# Run service with `5000` middlewares      /gem/lib/convenient_service/support/command.rb:26:in `call': stack level too deep (SystemStackError)
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:45:in `call'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/entities/method_chain.rb:47:in `next'
#         from benchmark/load/many_middlewares/bm.rb:26:in `next'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:58:in `call'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/entities/method_chain.rb:47:in `next'
#         from benchmark/load/many_middlewares/bm.rb:26:in `next'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:58:in `call'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/entities/method_chain.rb:47:in `next'
#          ... 9816 levels...
#         from benchmark/load/many_middlewares/bm.rb:58:in `block in <main>'
#         from /usr/local/lib/ruby/3.3.0/benchmark.rb:178:in `benchmark'
#         from /usr/local/lib/ruby/3.3.0/benchmark.rb:210:in `bm'
#         from benchmark/load/many_middlewares/bm.rb:57:in `<main>'
##
