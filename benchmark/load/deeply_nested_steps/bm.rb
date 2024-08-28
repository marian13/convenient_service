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
end

ATTEMPTS = [
  {nesting_levels: 1, steps_per_level: 10},
  {nesting_levels: 2, steps_per_level: 10},
  {nesting_levels: 3, steps_per_level: 10},
  {nesting_levels: 4, steps_per_level: 10}
]

KLASSES = []

def build_service(nesting_levels, steps_per_level)
  KLASSES <<
    nesting_levels.downto(1).reduce(SuccessService) do |composed_klass, nesting_level|
      Class.new.tap do |klass|
        klass.class_exec(composed_klass, nesting_level, steps_per_level) do |composed_klass, nesting_level, steps_per_level|
          include ConvenientService::Standard::Config

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
end

def run_service(klass)
  result = klass.result(index: "0_0")

  if result.success?
    result.data["id_1_#{klass.steps.size}"]
  else
    raise
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

    x.report("Run service   (n = `#{nesting[:levels]}`, s = `#{klass.steps.size}`, t = `#{klass.steps.size**nesting[:levels]}`)") { run_service(klass) }
  end
end

puts "\n`n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total"

##
# root@dd317c9e58c2:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
#
# root@dd317c9e58c2:/gem# ruby benchmark/load/deeply_nested_steps/bm.rb
#                                                          user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`)          0.005898   0.000000   0.005898 (  0.005914)
# Build service (n = `2`, s = `10`, t = `100`)         0.012406   0.000000   0.012406 (  0.012401)
# Build service (n = `3`, s = `10`, t = `1000`)        0.023170   0.000492   0.023662 (  0.023665)
# Build service (n = `4`, s = `10`, t = `10000`)       0.025206   0.000000   0.025206 (  0.025212)
#                                                          user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10`)          0.045114   0.000000   0.045114 (  0.045117)
# Run service   (n = `2`, s = `10`, t = `100`)         0.365679   0.000000   0.365679 (  0.366577)
# Run service   (n = `3`, s = `10`, t = `1000`)        3.550321   0.000000   3.550321 (  3.553825)
# Run service   (n = `4`, s = `10`, t = `10000`)      35.497345   0.044394  35.541739 ( 35.546635)
#
# `n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total
##

##
# root@21d4556b62db:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
#
# root@21d4556b62db:/gem# ruby benchmark/load/deeply_nested_steps/bm.rb
#                                                          user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`)          0.003899   0.002390   0.006289 (  0.007990)
# Build service (n = `2`, s = `10`, t = `100`)         0.013824   0.000000   0.013824 (  0.013888)
# Build service (n = `3`, s = `10`, t = `1000`)        0.037154   0.001260   0.038414 (  0.039340)
# Build service (n = `4`, s = `10`, t = `10000`)       0.024285   0.001829   0.026114 (  0.026592)
#                                                          user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10`)          0.023308   0.000000   0.023308 (  0.023602)
# Run service   (n = `2`, s = `10`, t = `100`)         0.158778   0.000429   0.159207 (  0.162602)
# Run service   (n = `3`, s = `10`, t = `1000`)        1.290493   0.011324   1.301817 (  1.301932)
# Run service   (n = `4`, s = `10`, t = `10000`)      14.057662   0.055574  14.113236 ( 14.113862)
#
# `n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total
##
