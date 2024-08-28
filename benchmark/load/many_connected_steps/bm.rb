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

STEPS_PER_SUPER_GROUP = 12

ATTEMPTS = [
  {super_groups_count: 1},
  {super_groups_count: 10},
  {super_groups_count: 25},
  {super_groups_count: 50},
  {super_groups_count: 100}
]

KLASSES = []

def build_service(super_groups_count)
  KLASSES <<
    Class.new.tap do |klass|
      klass.class_exec(super_groups_count) do |super_groups_count|
        include ConvenientService::Standard::Config

        attr_reader :index

        (0...super_groups_count).each do |i|
          group do
            step SuccessService,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 1)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 1}"}

            and_step :success_method,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 2)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 2}"}
          end

          not_group do
            step SuccessService,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 3)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 3}"}

            and_step :failure_method,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 4)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 4}"}
          end

          and_group do
            not_step FailureService,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 5)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 5}"}

            and_step :success_method,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 6)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 6}"}
          end

          and_not_group do
            step FailureService,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 7)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 7}"}

            or_step :success_method,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 8)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 8}"}
          end

          or_group do
            step FailureService,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 9)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 9}"}

            or_not_step :success_method,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 10)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 10}"}
          end

          or_not_group do
            step SuccessService,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 11)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 11}"}

            and_not_step :success_method,
              in: {index: raw(i * STEPS_PER_SUPER_GROUP + 12)},
              out: {id: "id_#{i * STEPS_PER_SUPER_GROUP + 12}"}
          end
        end

        def initialize(index:)
          @index = index
        end

        private

        def success_method(index:)
          success(id: index)
        end

        def failure_method(index:)
          failure("Message with id `#{index}`")
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
    super_groups_count = attempt[:super_groups_count]
    steps_count = super_groups_count * STEPS_PER_SUPER_GROUP

    x.report("Build service with `#{steps_count}` steps") { build_service(super_groups_count) }
  end
end

Benchmark.bm(30) do |x|
  KLASSES.each do |klass|
    x.report("Run service with `#{klass.steps.size}` steps") { run_service(klass) }
  end
end

##
# root@f9031ad86910:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
#
# root@dd317c9e58c2:/gem# ruby benchmark/load/many_connected_steps/bm.rb
#                                      user     system      total        real
# Build service with `12` steps    0.006847   0.000000   0.006847 (  0.006959)
# Build service with `120` steps   0.015260   0.000000   0.015260 (  0.015265)
# Build service with `300` steps   0.008580   0.000000   0.008580 (  0.008595)
# Build service with `600` steps   0.013891   0.000000   0.013891 (  0.014019)
# Build service with `1200` steps  0.029913   0.000000   0.029913 (  0.029975)
#                                      user     system      total        real
# Run service with `12` steps      0.063993   0.000000   0.063993 (  0.063999)
# Run service with `120` steps     1.037476   0.000000   1.037476 (  1.038443)
# Run service with `300` steps     5.532493   0.000000   5.532493 (  5.538719)
# Run service with `600` steps    20.765184   0.000000  20.765184 ( 20.782215)
# Run service with `1200` steps   80.275709   0.003929  80.279638 ( 80.306041)
##

##
# root@21d4556b62db:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
#
# root@21d4556b62db:/gem# ruby benchmark/load/many_connected_steps/bm.rb
#                                      user     system      total        real
# Build service with `12` steps    0.007251   0.000000   0.007251 (  0.009361)
# Build service with `120` steps   0.009905   0.000000   0.009905 (  0.009977)
# Build service with `300` steps   0.014820   0.000680   0.015500 (  0.015948)
# Build service with `600` steps   0.013302   0.000616   0.013918 (  0.013932)
# Build service with `1200` steps  0.031671   0.001632   0.033303 (  0.033320)
#                                      user     system      total        real
# Run service with `12` steps      0.032241   0.000451   0.032692 (  0.032715)
# Run service with `120` steps     0.322068   0.000000   0.322068 (  0.322104)
# Run service with `300` steps     1.389539   0.000000   1.389539 (  1.389572)
# Run service with `600` steps     5.100783   0.007542   5.108325 (  5.108779)
# Run service with `1200` steps   19.433406   0.042453  19.475859 ( 19.488352)
##

##
# root@47ba080093a1:/gem# ruby -v
# jruby 9.4.5.0 (3.1.4) 2023-11-02 1abae2700f OpenJDK 64-Bit Server VM 25.392-b08 on 1.8.0_392-b08 +jit [x86_64-linux]
# root@47ba080093a1:/gem# ruby benchmark/load/many_connected_steps/bm.rb
#                                      user     system      total        real
# Build service with `12` steps    0.180000   0.010000   0.190000 (  0.067743)
# Build service with `120` steps   0.220000   0.030000   0.250000 (  0.105525)
# Build service with `300` steps   0.400000   0.040000   0.440000 (  0.146874)
# Build service with `600` steps   0.590000   0.050000   0.640000 (  0.206449)
# Build service with `1200` steps  0.720000   0.060000   0.780000 (  0.285066)
#                                      user     system      total        real
# Run service with `12` steps      1.000000   0.140000   1.140000 (  0.331651)
# Run service with `120` steps     6.940000   0.490000   7.430000 (  2.000689)
# Run service with `300` steps     5.520000   0.260000   5.780000 (  2.637347)
# Run service with `600` steps     8.040000   0.190000   8.230000 (  6.103952)
# Run service with `1200` steps   22.080000   0.220000  22.300000 ( 19.345403)
##
