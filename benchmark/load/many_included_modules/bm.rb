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

module Methods
  def foo
    :foo
  end
end

def build_service(modules_count)
  KLASSES <<
    Class.new.tap do |klass|
      klass.class_exec(modules_count) do |modules_count|
        include ConvenientService::Standard::Config

        include Methods

        modules_count.times { include Module.new }

        def result
          success(foo: foo)
        end
      end
  end
end

def run_service(klass)
  result = klass.result

  if result.success?
    result.data[:foo]
  else
    raise "Something went wrong..."
  end
end

Benchmark.bm(50) do |x|
  ATTEMPTS.each do |attempt|
    x.report("Build service with `#{attempt[:modules_count]}` included modules") { build_service(attempt[:modules_count]) }
  end
end

Benchmark.bm(50) do |x|
  KLASSES.each do |klass|
    x.report("Run service with `#{klass.included_modules.count { |mod| mod.name.nil? }}` included modules") { run_service(klass) }
  end
end

##
# root@3fba6044abd9:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
# root@3fba6044abd9:/gem# ruby benchmark/load/many_included_modules/bm.rb
#                                                          user     system      total        real
# Build service with `100` included modules            0.006556   0.000000   0.006556 (  0.006573)
# Build service with `500` included modules            0.006102   0.000000   0.006102 (  0.006110)
# Build service with `1000` included modules           0.010837   0.000000   0.010837 (  0.010839)
# Build service with `5000` included modules           0.093101   0.002162   0.095263 (  0.095367)
# Build service with `10000` included modules          0.297746   0.002074   0.299820 (  0.299924)
#                                                          user     system      total        real
# Run service with `101` included modules              0.003431   0.000086   0.003517 (  0.003515)
# Run service with `501` included modules              0.003032   0.000000   0.003032 (  0.003038)
# Run service with `1001` included modules             0.006568   0.000000   0.006568 (  0.006569)
# Run service with `5001` included modules             0.005889   0.000035   0.005924 (  0.005931)
# Run service with `10001` included modules            0.008717   0.000000   0.008717 (  0.008719)
##

##
# root@21d4556b62db:/gem# ruby -v
# ruby 3.3.4 (2024-07-09 revision be1089c8ec) [x86_64-linux]
# root@21d4556b62db:/gem# ruby benchmark/load/many_included_modules/bm.rb
#                                                          user     system      total        real
# Build service with `100` included modules            0.008054   0.000000   0.008054 (  0.008067)
# Build service with `500` included modules            0.006050   0.000911   0.006961 (  0.006993)
# Build service with `1000` included modules           0.011523   0.000058   0.011581 (  0.011615)
# Build service with `5000` included modules           0.122516   0.000886   0.123402 (  0.123286)
# Build service with `10000` included modules          0.397359   0.000405   0.397764 (  0.398245)
#                                                          user     system      total        real
# Run service with `100` included modules              0.002985   0.000000   0.002985 (  0.004696)
# Run service with `500` included modules              0.002488   0.000000   0.002488 (  0.002489)
# Run service with `1000` included modules             0.003177   0.000000   0.003177 (  0.003180)
# Run service with `5000` included modules             0.006195   0.000017   0.006212 (  0.006215)
# Run service with `10000` included modules            0.009659   0.001103   0.010762 (  0.010822)
##
