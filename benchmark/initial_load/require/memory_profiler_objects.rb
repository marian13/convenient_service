# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# - https://github.com/SamSaffron/memory_profiler
# - https://github.com/zombocom/derailed_benchmarks/blob/v2.2.1/bin/derailed#L49
#
require "bundler/setup"

require "memory_profiler"
require "fileutils"
require "paint"

def print_progress
  print Paint[".", :green]
end

FileUtils.mkdir_p("tmp/objects_report")

MemoryProfiler
  .report { require "convenient_service" }
  .pretty_print(to_file: "tmp/objects_report/convenient_service.txt")
  .then { print_progress }

MemoryProfiler
  .report { require "service_actor" }
  .pretty_print(to_file: "tmp/objects_report/service_actor.txt")
  .then { print_progress }

MemoryProfiler
  .report { require "interactor" }
  .pretty_print(to_file: "tmp/objects_report/interactor.txt")
  .then { print_progress }

MemoryProfiler
  .report { require "trailblazer/operation" }
  .pretty_print(to_file: "tmp/objects_report/trailblazer-operation.txt")
  .then { print_progress }

MemoryProfiler
  .report { require "active_interaction" }
  .pretty_print(to_file: "tmp/objects_report/active_interaction.txt")
  .then { print_progress }

MemoryProfiler
  .report { require "light-service" }
  .pretty_print(to_file: "tmp/objects_report/light-service.txt")
  .then { print_progress }

MemoryProfiler
  .report { require "mutations" }
  .pretty_print(to_file: "tmp/objects_report/mutations.txt")
  .then { print_progress }

puts
puts "Output is saved into `tmp/objects_report` folder."
