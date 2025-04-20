# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "bundler/setup"
require "convenient_service"
require "benchmark"
require "benchmark/memory"

class Service
  include ConvenientService::Standard::Config

  def result
    success
  end
end

##
# Benchmarking of memory allocations.
#
Benchmark.memory do |x|
  x.report("Service.result - first attempt") { Service.result }
  x.report("Service.result - second attempt") { Service.result }
  x.report("Service.result - third attempt") { Service.result }
  x.report("Service.result - fourth attempt") { Service.result }
  x.report("Service.result - fifth attempt") { Service.result }
end

##
# root@b4432b776730:/gem# ruby -v
# ruby 2.7.8p225 (2023-03-30 revision 1f4d455848) [x86_64-linux]
# root@b4432b776730:/gem# ruby benchmark/regular_service/memory.rb
# Calculating -------------------------------------
# Service.result - first attempt
#                        287.104k memsize (     6.344k retained)
#                          3.342k objects (    79.000  retained)
#                         25.000  strings (     0.000  retained)
# Service.result - second attempt
#                        186.504k memsize (    72.000  retained)
#                          2.016k objects (     1.000  retained)
#                          5.000  strings (     0.000  retained)
# Service.result - third attempt
#                        186.504k memsize (    72.000  retained)
#                          2.016k objects (     1.000  retained)
#                          5.000  strings (     0.000  retained)
# Service.result - fourth attempt
#                        186.504k memsize (    72.000  retained)
#                          2.016k objects (     1.000  retained)
#                          5.000  strings (     0.000  retained)
# Service.result - fifth attempt
#                        186.504k memsize (    72.000  retained)
#                          2.016k objects (     1.000  retained)
#                          5.000  strings (     0.000  retained)
##

##
# root@75507aa9bce9:/gem# ruby -v
# ruby 3.4.0preview1 (2024-05-16 master 9d69619623) [x86_64-linux]
# root@75507aa9bce9:/gem# ruby benchmark/regular_service/memory.rb
# Calculating -------------------------------------
# Service.result - first attempt
#                        144.512k memsize (    13.728k retained)
#                          1.524k objects (   152.000  retained)
#                         40.000  strings (     7.000  retained)
# Service.result - second attempt
#                         52.320k memsize (   240.000  retained)
#                        494.000  objects (     3.000  retained)
#                          5.000  strings (     0.000  retained)
# Service.result - third attempt
#                         52.320k memsize (   240.000  retained)
#                        494.000  objects (     3.000  retained)
#                          5.000  strings (     0.000  retained)
# Service.result - fourth attempt
#                         52.320k memsize (   240.000  retained)
#                        494.000  objects (     3.000  retained)
#                          5.000  strings (     0.000  retained)
# Service.result - fifth attempt
#                         52.320k memsize (   240.000  retained)
#                        494.000  objects (     3.000  retained)
#                          5.000  strings (     0.000  retained)
##

##
# root@4cd6a9db87ad:/gem# ruby -v
# jruby 9.4.7.0 (3.1.4) 2024-04-29 597ff08ac1 OpenJDK 64-Bit Server VM 25.412-b08 on 1.8.0_412-b08 +jit [x86_64-linux]
# root@4cd6a9db87ad:/gem# ruby benchmark/regular_service/memory.rb
# Calculating -------------------------------------
# NoMethodError: undefined method `trace_object_allocations_start' for ObjectSpace:Module
#                          start at /usr/local/bundle/gems/memory_profiler-1.0.1/lib/memory_profiler/reporter.rb:42
#                            run at /usr/local/bundle/gems/memory_profiler-1.0.1/lib/memory_profiler/reporter.rb:74
#                         report at /usr/local/bundle/gems/memory_profiler-1.0.1/lib/memory_profiler/reporter.rb:33
#                         report at /usr/local/bundle/gems/memory_profiler-1.0.1/lib/memory_profiler.rb:16
#   while_measuring_memory_usage at /usr/local/bundle/gems/benchmark-memory-0.2.0/lib/benchmark/memory/job/task.rb:47
#                           call at /usr/local/bundle/gems/benchmark-memory-0.2.0/lib/benchmark/memory/job/task.rb:39
#       run_without_held_results at /usr/local/bundle/gems/benchmark-memory-0.2.0/lib/benchmark/memory/job.rb:131
#                       run_task at /usr/local/bundle/gems/benchmark-memory-0.2.0/lib/benchmark/memory/job.rb:102
#                            run at /usr/local/bundle/gems/benchmark-memory-0.2.0/lib/benchmark/memory/job.rb:82
#                           each at org/jruby/RubyArray.java:1981
#                            run at /usr/local/bundle/gems/benchmark-memory-0.2.0/lib/benchmark/memory/job.rb:81
#                         memory at /usr/local/bundle/gems/benchmark-memory-0.2.0/lib/benchmark/memory.rb:24
#                         <main> at benchmark/regular_service/memory.rb:20
##
