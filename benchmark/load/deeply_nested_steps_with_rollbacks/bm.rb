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

  def rollback_result
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

          def rollback_result
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
# root@dfa3422836e8:/gem# ruby benchmark/load/deeply_nested_steps_with_rollbacks/bm.rb
#                                                          user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`)          0.007456   0.000222   0.007678 (  0.007736)
# Build service (n = `2`, s = `10`, t = `100`)         0.018874   0.001032   0.019906 (  0.020163)
# Build service (n = `3`, s = `10`, t = `1000`)        0.014279   0.002144   0.016423 (  0.016484)
# Build service (n = `4`, s = `10`, t = `10000`)       0.024989   0.000092   0.025081 (  0.025147)
# Build service (n = `6`, s = `5`, t = `15625`)        0.036328   0.000893   0.037221 (  0.037267)
# Build service (n = `10`, s = `2`, t = `1024`)        0.073939   0.000201   0.074140 (  0.074215)
#                                                          user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10`)          0.045047   0.000103   0.045150 (  0.045169)
# Run service   (n = `2`, s = `10`, t = `100`)         0.365517   0.000309   0.365826 (  0.366001)
# Run service   (n = `3`, s = `10`, t = `1000`)        3.803584   0.002545   3.806129 (  3.817151)
# Run service   (n = `4`, s = `10`, t = `10000`)      36.962723   0.040090  37.002813 ( 37.010297)
# Run service   (n = `6`, s = `5`, t = `15625`)       60.250144   0.027011  60.277155 ( 60.295755)
# Run service   (n = `10`, s = `2`, t = `1024`)        6.063142   0.014998   6.078140 (  6.078286)
#
# `n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total
##

##
# root@21d4556b62db:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
#
# root@e8c727a352dd:/gem# ruby benchmark/load/deeply_nested_steps_with_rollbacks/bm.rb
#                                                          user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`)          0.006416   0.001054   0.007470 (  0.009036)
# Build service (n = `2`, s = `10`, t = `100`)         0.013039   0.000715   0.013754 (  0.013765)
# Build service (n = `3`, s = `10`, t = `1000`)        0.026814   0.000000   0.026814 (  0.026893)
# Build service (n = `4`, s = `10`, t = `10000`)       0.031042   0.000830   0.031872 (  0.032065)
# Build service (n = `6`, s = `5`, t = `15625`)        0.051545   0.000217   0.051762 (  0.051764)
# Build service (n = `10`, s = `2`, t = `1024`)        0.079135   0.000000   0.079135 (  0.079290)
#                                                          user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10`)          0.024478   0.000000   0.024478 (  0.024486)
# Run service   (n = `2`, s = `10`, t = `100`)         0.137648   0.000000   0.137648 (  0.137853)
# Run service   (n = `3`, s = `10`, t = `1000`)        1.312362   0.002185   1.314547 (  1.314583)
# Run service   (n = `4`, s = `10`, t = `10000`)      14.422837   0.052969  14.475806 ( 14.477802)
# Run service   (n = `6`, s = `5`, t = `15625`)       24.510600   0.054775  24.565375 ( 24.568032)
# Run service   (n = `10`, s = `2`, t = `1024`)        2.272135   0.005993   2.278128 (  2.278185)
#
# `n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total
##
