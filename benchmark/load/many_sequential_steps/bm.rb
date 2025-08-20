# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "bundler/setup"

# require "convenient_service/dependencies/only_development_tools"
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
  {steps_count: 12},
  {steps_count: 120},
  {steps_count: 300},
  {steps_count: 600},
  {steps_count: 1200}
]

KLASSES = []

def build_service(steps_count)
  KLASSES <<
    Class.new.tap do |klass|
      klass.class_exec(steps_count) do |steps_count|
        include ConvenientService::Standard::Config

        attr_reader :index

        1.upto(steps_count) do |index|
          step SuccessService,
            in: {index: raw(index)},
            out: {id: "id_#{index}"}
        end

        def initialize(index:)
          @index = index
        end
      end
    end
end

def run_service(klass)
  result = klass.result(index: 0)

  if result.success?
    result.data["id_#{klass.steps.size}"]
  else
    raise "Something went wrong..."
  end
end

Benchmark.bm(30) do |x|
  ATTEMPTS.each do |attempt|
    x.report("Build service with `#{attempt[:steps_count]}` steps") { build_service(attempt[:steps_count]) }
  end
end

Benchmark.bm(30) do |x|
  KLASSES.each do |klass|
    x.report("Run service with `#{klass.steps.size}` steps") { run_service(klass) }
  end
end

##
# root@dd317c9e58c2:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
#
# root@dd317c9e58c2:/gem# ruby benchmark/load/many_sequential_steps/bm.rb
#                                      user     system      total        real
# Build service with `12` steps    0.006132   0.000000   0.006132 (  0.006160)
# Build service with `120` steps   0.007999   0.000000   0.007999 (  0.008006)
# Build service with `300` steps   0.016107   0.000000   0.016107 (  0.016110)
# Build service with `600` steps   0.011555   0.000353   0.011908 (  0.011923)
# Build service with `1200` steps  0.023375   0.000000   0.023375 (  0.023367)
#                                      user     system      total        real
# Run service with `12` steps      0.066144   0.002108   0.068252 (  0.068259)
# Run service with `120` steps     1.275149   0.000000   1.275149 (  1.275192)
# Run service with `300` steps     6.842291   0.000000   6.842291 (  6.842566)
# Run service with `600` steps    25.864800   0.006700  25.871500 ( 25.877727)
# Run service with `1200` steps   99.387705   0.009834  99.397539 ( 99.414330)
##

##
# root@21d4556b62db:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
#
# root@21d4556b62db:/gem# ruby benchmark/load/many_sequential_steps/bm.rb
#                                      user     system      total        real
# Build service with `12` steps    0.005072   0.000885   0.005957 (  0.007473)
# Build service with `120` steps   0.009746   0.000061   0.009807 (  0.010176)
# Build service with `300` steps   0.014132   0.000537   0.014669 (  0.015197)
# Build service with `600` steps   0.011570   0.000000   0.011570 (  0.011729)
# Build service with `1200` steps  0.027850   0.000000   0.027850 (  0.028210)
#                                      user     system      total        real
# Run service with `12` steps      0.024445   0.001330   0.025775 (  0.025974)
# Run service with `120` steps     0.354659   0.000000   0.354659 (  0.354984)
# Run service with `300` steps     1.644035   0.000000   1.644035 (  1.644967)
# Run service with `600` steps     6.293388   0.000000   6.293388 (  6.294154)
# Run service with `1200` steps   24.376835   0.050411  24.427246 ( 24.433325)
##
