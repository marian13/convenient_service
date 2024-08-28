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
  {nesting_levels: 4, steps_per_level: 10},
  {nesting_levels: 6, steps_per_level: 5},
  {nesting_levels: 10, steps_per_level: 2}
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

    x.report("Run service   (n = `#{nesting[:levels]}`, s = `#{klass.steps.size}`, t = `#{klass.steps.size**nesting[:levels]}`)") { run_service(klass) }
  end
end

puts "\n`n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total"

##
# root@dd317c9e58c2:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
#
# root@dfa3422836e8:/gem# ruby benchmark/load/deeply_nested_steps/bm.rb
#                                                          user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`)          0.006002   0.000000   0.006002 (  0.006091)
# Build service (n = `2`, s = `10`, t = `100`)         0.017273   0.000000   0.017273 (  0.017282)
# Build service (n = `3`, s = `10`, t = `1000`)        0.019433   0.000733   0.020166 (  0.020161)
# Build service (n = `4`, s = `10`, t = `10000`)       0.029237   0.001829   0.031066 (  0.031158)
# Build service (n = `6`, s = `5`, t = `15625`)        0.039978   0.001461   0.041439 (  0.041576)
# Build service (n = `10`, s = `2`, t = `1024`)        0.078765   0.001385   0.080150 (  0.080251)
#                                                          user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10`)          0.044335   0.000791   0.045126 (  0.045132)
# Run service   (n = `2`, s = `10`, t = `100`)         0.354018   0.000000   0.354018 (  0.354471)
# Run service   (n = `3`, s = `10`, t = `1000`)        3.600247   0.002946   3.603193 (  3.609758)
# Run service   (n = `4`, s = `10`, t = `10000`)      36.261000   0.032820  36.293820 ( 36.313460)
# Run service   (n = `6`, s = `5`, t = `15625`)       56.163039   0.046864  56.209903 ( 56.224645)
# Run service   (n = `10`, s = `2`, t = `1024`)        6.044170   0.000981   6.045151 (  6.049136)
#
# `n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total
##

##
# root@21d4556b62db:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
#
# root@e8c727a352dd:/gem# ruby benchmark/load/deeply_nested_steps/bm.rb
#                                                          user     system      total        real
# Build service (n = `1`, s = `10`, t = `10`)          0.005523   0.000170   0.005693 (  0.007036)
# Build service (n = `2`, s = `10`, t = `100`)         0.014445   0.000000   0.014445 (  0.014555)
# Build service (n = `3`, s = `10`, t = `1000`)        0.026700   0.000502   0.027202 (  0.027356)
# Build service (n = `4`, s = `10`, t = `10000`)       0.028153   0.000000   0.028153 (  0.028310)
# Build service (n = `6`, s = `5`, t = `15625`)        0.052858   0.000494   0.053352 (  0.053547)
# Build service (n = `10`, s = `2`, t = `1024`)        0.067062   0.000424   0.067486 (  0.067681)
#                                                          user     system      total        real
# Run service   (n = `1`, s = `10`, t = `10`)          0.030767   0.000757   0.031524 (  0.031591)
# Run service   (n = `2`, s = `10`, t = `100`)         0.133289   0.000434   0.133723 (  0.133909)
# Run service   (n = `3`, s = `10`, t = `1000`)        1.313196   0.000000   1.313196 (  1.321067)
# Run service   (n = `4`, s = `10`, t = `10000`)      13.921593   0.049685  13.971278 ( 13.977973)
# Run service   (n = `6`, s = `5`, t = `15625`)       23.526314   0.070861  23.597175 ( 23.606293)
# Run service   (n = `10`, s = `2`, t = `1024`)        2.223812   0.005993   2.229805 (  2.230141)
#
# `n` stands for nesting levels, `s` - for steps per level, `t` - for steps in total
##
