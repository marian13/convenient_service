# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "bundler/setup"
require "convenient_service"
require "benchmark"

class SuccessService
  include ConvenientService::Standard::Config

  attr_reader :index

  def initialize(index:)
    @index = index
  end

  def result
    success(id: index)
  end
end

ATTEMPTS = [
  {nesting_levels: 1, steps_per_level: 10, middlewares_per_service: 500},
  {nesting_levels: 2, steps_per_level: 10, middlewares_per_service: 500},
  {nesting_levels: 3, steps_per_level: 10, middlewares_per_service: 500},
  {nesting_levels: 4, steps_per_level: 10, middlewares_per_service: 500},
  {nesting_levels: 6, steps_per_level: 5, middlewares_per_service: 500},
  {nesting_levels: 10, steps_per_level: 2, middlewares_per_service: 500}
]

KLASSES = []

def build_service(nesting_levels, steps_per_level, middlewares_per_service)
  success_service =
    Class.new.tap do |klass|
      klass.class_exec(middlewares_per_service) do |middlewares_per_service|
        include ConvenientService::Standard::Config

        attr_reader :index

        1.upto(middlewares_per_service) do |index|
          middlewares :result do
            middleware = Class.new(ConvenientService::MethodChainMiddleware) do
              def next(...)
                chain.next(...)
              end
            end

            prepend middleware
          end
        end

        def initialize(index:)
          @index = index
        end

        def result
          success(id: index)
        end
      end
    end

  KLASSES <<
    nesting_levels.downto(1).reduce(success_service) do |composed_klass, nesting_level|
      Class.new.tap do |klass|
        klass.class_exec(composed_klass, nesting_level, steps_per_level, middlewares_per_service) do |composed_klass, nesting_level, steps_per_level, middlewares_per_service|
          include ConvenientService::Standard::Config

          attr_reader :nesting_level, :index

          1.upto(middlewares_per_service) do |index|
            middlewares :result do
              middleware = Class.new(ConvenientService::MethodChainMiddleware) do
                def next(...)
                  chain.next(...)
                end
              end

              prepend middleware
            end
          end

          1.upto(steps_per_level) do |index|
            step composed_klass,
              in: {index: raw("#{nesting_level}_#{index}")},
              out: [
                :id,
                {id: "id_#{nesting_level}_#{index}"}
              ]
          end

          def initialize(index:)
            @index = index
          end
        end
      end
    end
end

def run_service(klass)
  result = klass.result(index: "0_0")

  if result.success?
    result.data["id_1_#{klass.steps.size}"]
  else
    raise "Something went wrong..."
  end
end

Benchmark.bm(60) do |x|
  ATTEMPTS.each do |attempt|
    nesting_levels, steps_per_level, middlewares_per_service = attempt.values_at(:nesting_levels, :steps_per_level, :middlewares_per_service)

    x.report("Build service (n = `#{nesting_levels}`, s = `#{steps_per_level}`, t = `#{steps_per_level**nesting_levels}`, m = `#{middlewares_per_service}`)") { build_service(nesting_levels, steps_per_level, middlewares_per_service) }
  end
end

Benchmark.bm(60) do |x|
  KLASSES.each do |klass|
    nesting = Enumerator.produce({levels: 0, klass: klass}) { |nesting| nesting[:klass].steps.any? ? {levels: nesting[:levels] + 1, klass: nesting[:klass].steps.first.action} : raise(StopIteration) }.to_a.last

    middlewares_per_service = klass.middlewares(:result).to_a.count { |middleware| middleware.name.nil? }

    x.report("Run service   (n = `#{nesting[:levels]}`, s = `#{klass.steps.size}`, t = `#{klass.steps.size**nesting[:levels]}, m = `#{middlewares_per_service}`)") { run_service(klass) }
  end
end

puts "\n`n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total, `m` - for middlewares per service"

##
# root@cc80940a7e23:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
#
# root@cc80940a7e23:/gem# ruby benchmark/load/many_nested_middlewares/bm.rb
#                                                                    user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`, m = `500`)         0.035984   0.000000   0.035984 (  0.037990)
# Build service (n = `2`, s = `10`, t = `100`, m = `500`)        0.040643   0.000697   0.041340 (  0.043058)
# Build service (n = `3`, s = `10`, t = `1000`, m = `500`)       0.057959   0.001484   0.059443 (  0.062594)
# Build service (n = `4`, s = `10`, t = `10000`, m = `500`)      0.061817   0.000507   0.062324 (  0.065513)
# Build service (n = `6`, s = `5`, t = `15625`, m = `500`)       0.091975   0.002398   0.094373 (  0.094412)
# Build service (n = `10`, s = `2`, t = `1024`, m = `500`)       0.147999   0.005515   0.153514 (  0.153581)
#                                                                    user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10, m = `500`)          0.074403   0.000000   0.074403 (  0.074470)
# Run service   (n = `2`, s = `10`, t = `100, m = `500`)         0.870991   0.000890   0.871881 (  0.871918)
# Run service   (n = `3`, s = `10`, t = `1000, m = `500`)        7.474336   0.005177   7.479513 (  7.480075)
# Run service   (n = `4`, s = `10`, t = `10000, m = `500`)      73.293633   0.040361  73.333994 ( 73.355509)
# Run service   (n = `6`, s = `5`, t = `15625, m = `500`)      Traceback (most recent call last):
#         10088: from benchmark/load/many_nested_middlewares/bm.rb:117:in `<main>'
#         10087: from /usr/local/lib/ruby/2.7.0/benchmark.rb:205:in `bm'
#         10086: from /usr/local/lib/ruby/2.7.0/benchmark.rb:173:in `benchmark'
#         10085: from benchmark/load/many_nested_middlewares/bm.rb:118:in `block in <main>'
#         10084: from benchmark/load/many_nested_middlewares/bm.rb:118:in `each'
#         10083: from benchmark/load/many_nested_middlewares/bm.rb:123:in `block (2 levels) in <main>'
#         10082: from /usr/local/lib/ruby/2.7.0/benchmark.rb:375:in `item'
#         10081: from /usr/local/lib/ruby/2.7.0/benchmark.rb:293:in `measure'
#          ... 10076 levels...
#             4: from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:58:in `call'
#             3: from benchmark/load/many_nested_middlewares/bm.rb:44:in `next'
#             2: from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/entities/method_chain.rb:47:in `next'
#             1: from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:45:in `call'
# /gem/lib/convenient_service/support/command.rb:26:in `call': stack level too deep (SystemStackError)
##

##
# root@f23f41addbe0:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
#
# root@f23f41addbe0:/gem# ruby benchmark/load/many_nested_middlewares/bm.rb
#                                                                    user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`, m = `500`)         0.029862   0.000642   0.030504 (  0.031521)           [0/1964]
# Build service (n = `2`, s = `10`, t = `100`, m = `500`)        0.047517   0.000779   0.048296 (  0.048300)
# Build service (n = `3`, s = `10`, t = `1000`, m = `500`)       0.062965   0.000000   0.062965 (  0.062967)
# Build service (n = `4`, s = `10`, t = `10000`, m = `500`)      0.078523   0.003332   0.081855 (  0.082045)
# Build service (n = `6`, s = `5`, t = `15625`, m = `500`)       0.091003   0.004678   0.095681 (  0.095723)
# Build service (n = `10`, s = `2`, t = `1024`, m = `500`)       0.168280   0.002559   0.170839 (  0.171048)
#                                                                    user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10, m = `500`)          0.090286   0.002762   0.093048 (  0.093050)
# Run service   (n = `2`, s = `10`, t = `100, m = `500`)         0.586100   0.002261   0.588361 (  0.588600)
# Run service   (n = `3`, s = `10`, t = `1000, m = `500`)        6.122335   0.011970   6.134305 (  6.135233)
# Run service   (n = `4`, s = `10`, t = `10000, m = `500`)      56.010518   0.162782  56.173300 ( 56.186110)
# Run service   (n = `6`, s = `5`, t = `15625, m = `500`)      /gem/lib/convenient_service/support/command.rb:26:in `new': stack level too deep (SystemStackError)
#         from /gem/lib/convenient_service/support/command.rb:26:in `call'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:45:in `call'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/entities/method_chain.rb:47:in `next'
#         from benchmark/load/many_nested_middlewares/bm.rb:44:in `next'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:58:in `call'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/entities/method_chain.rb:47:in `next'
#         from benchmark/load/many_nested_middlewares/bm.rb:44:in `next'
#         from /gem/lib/convenient_service/core/entities/config/entities/method_middlewares/entities/middlewares/chain/concern/instance_methods.rb:58:in `call'
#          ... 9831 levels...
#         from benchmark/load/many_nested_middlewares/bm.rb:118:in `block in <main>'
#         from /usr/local/lib/ruby/3.3.0/benchmark.rb:178:in `benchmark'
#         from /usr/local/lib/ruby/3.3.0/benchmark.rb:210:in `bm'
#         from benchmark/load/many_nested_middlewares/bm.rb:117:in `<main>'
##
