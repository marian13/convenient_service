# frozen_string_literal: true

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

  def rollback_result
  end
end

class FailureService
  include ConvenientService::Standard::Config

  attr_reader :index

  def initialize(index:)
    @index = index
  end

  def result
    failure("Message with id `#{index}`")
  end
end

ATTEMPTS = [
  {nesting_levels: 1, steps_per_level: 10},
  {nesting_levels: 2, steps_per_level: 10},
  {nesting_levels: 3, steps_per_level: 10},
  {nesting_levels: 4, steps_per_level: 10},
  {nesting_levels: 6, steps_per_level: 5},
  {nesting_levels: 10, steps_per_level: 2}
]

KLASSES = []

def build_service(nesting_levels, steps_per_level)
  composed_klass =
    nesting_levels.downto(1).reduce(SuccessService) do |composed_klass, nesting_level|
      Class.new.tap do |klass|
        klass.class_exec(composed_klass, nesting_level, steps_per_level) do |composed_klass, nesting_level, steps_per_level|
          include ConvenientService::Standard::Config
          include ConvenientService::Rollbacks::Config

          attr_reader :nesting_level, :index

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

  composed_klass.step FailureService,
    in: {index: composed_klass.raw("1_#{steps_per_level + 1}")},
    out: [
      :id,
      {id: "id_1_#{steps_per_level + 1}"}
    ]

  KLASSES << composed_klass
end

def run_service(klass)
  result = klass.result(index: "0_0")

  if result.failure?
    result.message
  else
    raise "Something went wrong..."
  end
end

Benchmark.bm(50) do |x|
  ATTEMPTS.each do |attempt|
    nesting_levels, steps_per_level = attempt.values_at(:nesting_levels, :steps_per_level)

    x.report("Build service (n = `#{nesting_levels}`, s = `#{steps_per_level}`, t = `#{steps_per_level**nesting_levels}`)") { build_service(nesting_levels, steps_per_level) }
  end
end

Benchmark.bm(50) do |x|
  KLASSES.each do |klass|
    nesting = Enumerator.produce({levels: 0, klass: klass}) { |nesting| nesting[:klass].steps.any? ? {levels: nesting[:levels] + 1, klass: nesting[:klass].steps.first.action} : raise(StopIteration) }.to_a.last

    x.report("Run service   (n = `#{nesting[:levels]}`, s = `#{klass.steps.size - 1}`, t = `#{(klass.steps.size - 1)**nesting[:levels]}`)") { run_service(klass) }
  end
end

puts "\n`n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total"

##
# root@dd317c9e58c2:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
#
# root@dfa3422836e8:/gem# ruby benchmark/load/deeply_nested_steps_without_rollbacks/bm.rb
#                                                          user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`)          0.006852   0.000290   0.007142 (  0.007481)
# Build service (n = `2`, s = `10`, t = `100`)         0.020594   0.000000   0.020594 (  0.020607)
# Build service (n = `3`, s = `10`, t = `1000`)        0.017070   0.000000   0.017070 (  0.017096)
# Build service (n = `4`, s = `10`, t = `10000`)       0.028735   0.001494   0.030229 (  0.030245)
# Build service (n = `6`, s = `5`, t = `15625`)        0.039307   0.000928   0.040235 (  0.040251)
# Build service (n = `10`, s = `2`, t = `1024`)        0.078949   0.001710   0.080659 (  0.080673)
#                                                          user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10`)          0.049447   0.000000   0.049447 (  0.049478)
# Run service   (n = `2`, s = `10`, t = `100`)         0.397519   0.000000   0.397519 (  0.397566)
# Run service   (n = `3`, s = `10`, t = `1000`)        3.724210   0.004491   3.728701 (  3.728876)
# Run service   (n = `4`, s = `10`, t = `10000`)      37.346693   0.056833  37.403526 ( 37.416038)
# Run service   (n = `6`, s = `5`, t = `15625`)       60.733940   0.023949  60.757889 ( 60.769694)
# Run service   (n = `10`, s = `2`, t = `1024`)        6.111366   0.004993   6.116359 (  6.118495)

# `n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total
##

##
# root@21d4556b62db:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
#
# root@e8c727a352dd:/gem# ruby benchmark/load/deeply_nested_steps_without_rollbacks/bm.rb
#                                                          user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`)          0.005647   0.000000   0.005647 (  0.007098)
# Build service (n = `2`, s = `10`, t = `100`)         0.014694   0.000025   0.014719 (  0.014755)
# Build service (n = `3`, s = `10`, t = `1000`)        0.023782   0.001789   0.025571 (  0.025637)
# Build service (n = `4`, s = `10`, t = `10000`)       0.031825   0.000766   0.032591 (  0.032629)
# Build service (n = `6`, s = `5`, t = `15625`)        0.049728   0.003033   0.052761 (  0.052826)
# Build service (n = `10`, s = `2`, t = `1024`)        0.074227   0.002784   0.077011 (  0.077055)
#                                                          user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10`)          0.025996   0.000000   0.025996 (  0.026048)
# Run service   (n = `2`, s = `10`, t = `100`)         0.141945   0.000000   0.141945 (  0.142036)
# Run service   (n = `3`, s = `10`, t = `1000`)        1.330203   0.003495   1.333698 (  1.334228)
# Run service   (n = `4`, s = `10`, t = `10000`)      14.386424   0.044441  14.430865 ( 14.448967)
# Run service   (n = `6`, s = `5`, t = `15625`)       24.321551   0.077910  24.399461 ( 24.416827)
# Run service   (n = `10`, s = `2`, t = `1024`)        2.424375   0.002003   2.426378 (  2.426820)
#
# `n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total
##
