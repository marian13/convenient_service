# frozen_string_literal: true

require "bundler/setup"
require "convenient_service"
require "benchmark"

ConvenientService::Dependencies.require_awesome_print_inspect
ConvenientService::Dependencies.require_standard_examples

# rubocop:disable Style/MixinUsage
include ConvenientService::Examples::Standard::ComprehensiveSuite::Services
# rubocop:enable Style/MixinUsage

ATTEMPTS = [1, 10, 25, 50, 100]
STEPS_PER_ITERATION = 12

KLASSES = []

def build_service(iterations)
  KLASSES << Class.new.tap do |klass|
    klass.class_exec(iterations) do |iterations|
      include ConvenientService::Standard::Config

      def self.in_index_value(index, iteration)
        index + STEPS_PER_ITERATION * iteration
      end

      def self.out_index_name(index, iteration)
        "index_#{index + STEPS_PER_ITERATION * iteration}"
      end

      iterations.times do |iteration|
        group do
          step SuccessService,
            in: {index: raw(in_index_value(0, iteration))},
            out: {index: out_index_name(0, iteration)}

          and_step :success_method,
            in: {index: raw(in_index_value(1, iteration))},
            out: {index: out_index_name(1, iteration)}
        end

        not_group do
          step SuccessService,
            in: {index: raw(in_index_value(2, iteration))},
            out: {index: out_index_name(2, iteration)}

          and_step :failure_method,
            in: {index: raw(in_index_value(3, iteration))},
            out: {index: out_index_name(3, iteration)}
        end

        and_group do
          not_step FailureService,
            in: {index: raw(in_index_value(4, iteration))},
            out: {index: out_index_name(4, iteration)}

          and_step :success_method,
            in: {index: raw(in_index_value(5, iteration))},
            out: {index: out_index_name(5, iteration)}
        end

        and_not_group do
          step FailureService,
            in: {index: raw(in_index_value(6, iteration))},
            out: {index: out_index_name(6, iteration)}

          or_step :success_method,
            in: {index: raw(in_index_value(7, iteration))},
            out: {index: out_index_name(7, iteration)}
        end

        or_group do
          step FailureService,
            in: {index: raw(in_index_value(8, iteration))},
            out: {index: out_index_name(8, iteration)}

          or_not_step :success_method,
            in: {index: raw(in_index_value(9, iteration))},
            out: {index: out_index_name(9, iteration)}
        end

        or_not_group do
          step SuccessService,
            in: {index: raw(in_index_value(10, iteration))},
            out: {index: out_index_name(10, iteration)}

          and_not_step :success_method,
            in: {index: raw(in_index_value(11, iteration))},
            out: {index: out_index_name(11, iteration)}
        end
      end

      private

      def success_method(index:)
        success(index: index)
      end

      def failure_method(index:)
        failure(index: index)
      end
    end
  end
end

def run_service(klass)
  klass.result
end

Benchmark.bm(30) do |x|
  ATTEMPTS.each do |iterations|
    x.report("Build service with `#{iterations * STEPS_PER_ITERATION}` steps") { build_service(iterations) }
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
# root@f9031ad86910:/gem# ruby benchmark/stress/bm.rb
#                                      user     system      total        real
# Build service with `12` steps    0.006079   0.000014   0.006093 (  0.006313)
# Build service with `120` steps   0.018545   0.000127   0.018672 (  0.019022)
# Build service with `300` steps   0.040518   0.000000   0.040518 (  0.040699)
# Build service with `600` steps   0.100366   0.000000   0.100366 (  0.100775)
# Build service with `1200` steps  0.125697   0.000000   0.125697 (  0.125841)
#                                      user     system      total        real
# Run service with `12` steps      0.040985   0.000000   0.040985 (  0.041152)
# Run service with `120` steps     0.900073   0.000377   0.900450 (  0.901147)
# Run service with `300` steps     4.880947   0.001594   4.882541 (  4.885424)
# Run service with `600` steps    16.726632   0.006868  16.733500 ( 16.749983)
# Run service with `1200` steps   65.127922   0.005161  65.133083 ( 65.160912)
##

##
# root@2e8a2e361492:/gem# ruby -v
# ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [x86_64-linux]
#
# root@2e8a2e361492:/gem# ruby benchmark/stress/bm.rb
# /gem/lib/convenient_service/dependencies/built_in.rb:36: warning: observer was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0. Add observer to your Gemfile or gemspec.
#                                      user     system      total        real
# Build service with `12` steps    0.007629   0.000000   0.007629 (  0.007775)
# Build service with `120` steps   0.022653   0.000000   0.022653 (  0.022785)
# Build service with `300` steps   0.014487   0.000011   0.014498 (  0.014603)
# Build service with `600` steps   0.030176   0.000000   0.030176 (  0.030368)
# Build service with `1200` steps  0.048074   0.000000   0.048074 (  0.048215)
#                                      user     system      total        real
# Run service with `12` steps      0.040410   0.000118   0.040528 (  0.040725)
# Run service with `120` steps     0.270620   0.000000   0.270620 (  0.270726)
# Run service with `300` steps     1.210959   0.000000   1.210959 (  1.215612)
# Run service with `600` steps     4.110843   0.006012   4.116855 (  4.121371)
# Run service with `1200` steps   15.619967   0.023563  15.643530 ( 15.647630)
##

##
# root@47ba080093a1:/gem# ruby -v
# jruby 9.4.5.0 (3.1.4) 2023-11-02 1abae2700f OpenJDK 64-Bit Server VM 25.392-b08 on 1.8.0_392-b08 +jit [x86_64-linux]
# root@47ba080093a1:/gem# ruby benchmark/stress/bm.rb
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
