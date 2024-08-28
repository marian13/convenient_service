# frozen_string_literal: true

require "bundler/setup"
require "convenient_service"
require "benchmark"

ATTEMPTS = [
  {modules_count: 100},
  {modules_count: 500},
  {modules_count: 1000},
  {modules_count: 5000},
  {modules_count: 10000}
]

KLASSES = []

def build_service(modules_count)
  KLASSES <<
    Class.new.tap do |klass|
      klass.class_exec(modules_count) do |modules_count|
        include ConvenientService::Standard::Config
        include ConvenientService::FaultTolerance::Config

        modules_count.times { include Module.new }

        def result
          success(foo: foo)
        end
      end
    end
end

def run_service(klass)
  result = klass.result

  if result.error?
    result.message
  else
    raise "Something went wrong..."
  end
end

Benchmark.bm(50) do |x|
  ATTEMPTS.each do |attempt|
    x.report("Build service with missing method (m = `#{attempt[:modules_count]}`)") { build_service(attempt[:modules_count]) }
  end
end

Benchmark.bm(50) do |x|
  KLASSES.each do |klass|
    x.report("Run service with missing method   (m = `#{klass.included_modules.count { |mod| mod.name.nil? }}`)") { run_service(klass) }
  end
end

puts "\n`m` stands for count of included modules"

##
# root@3fba6044abd9:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
# root@3fba6044abd9:/gem# ruby benchmark/load/many_included_modules_with_missing_method/bm.rb
#                                                          user     system      total        real
# Build service with missing method (m = `100`)        0.009159   0.000000   0.009159 (  0.012529)
# Build service with missing method (m = `500`)        0.006798   0.000000   0.006798 (  0.007093)
# Build service with missing method (m = `1000`)       0.013529   0.000084   0.013613 (  0.017089)
# Build service with missing method (m = `5000`)       0.105896   0.001637   0.107533 (  0.111938)
# Build service with missing method (m = `10000`)      0.261007   0.004288   0.265295 (  0.266981)
#                                                          user     system      total        real
# Run service with missing method   (m = `101`)        0.005362   0.000000   0.005362 (  0.005574)
# Run service with missing method   (m = `501`)        0.008868   0.000000   0.008868 (  0.011696)
# Run service with missing method   (m = `1001`)       0.005023   0.000476   0.005499 (  0.005739)
# Run service with missing method   (m = `5001`)       0.009362   0.000000   0.009362 (  0.011853)
# Run service with missing method   (m = `10001`)      0.012003   0.000033   0.012036 (  0.012429)
#
# `m` stands for count of included modules
##

##
# root@21d4556b62db:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
# root@21d4556b62db:/gem# ruby benchmark/load/many_included_modules_with_missing_method/bm.rb
#                                                          user     system      total        real
# Build service with missing method (m = `100`)        0.007851   0.000000   0.007851 (  0.007866)
# Build service with missing method (m = `500`)        0.007822   0.000000   0.007822 (  0.007995)
# Build service with missing method (m = `1000`)       0.009647   0.000000   0.009647 (  0.009653)
# Build service with missing method (m = `5000`)       0.127710   0.000964   0.128674 (  0.128684)
# Build service with missing method (m = `10000`)      0.435152   0.000000   0.435152 (  0.435164)
#                                                          user     system      total        real
# Run service with missing method   (m = `100`)        0.005195   0.000000   0.005195 (  0.006874)
# Run service with missing method   (m = `500`)        0.003172   0.000000   0.003172 (  0.003182)
# Run service with missing method   (m = `1000`)       0.003417   0.000000   0.003417 (  0.003413)
# Run service with missing method   (m = `5000`)       0.006931   0.000000   0.006931 (  0.006955)
# Run service with missing method   (m = `10000`)      0.011681   0.000000   0.011681 (  0.011704)
#
# `m` stands for count of included modules
##
