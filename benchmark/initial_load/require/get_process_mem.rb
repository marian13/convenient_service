# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# - https://github.com/zombocom/get_process_mem
# - https://github.com/zombocom/derailed_benchmarks/blob/v2.2.1/bin/derailed#L64
# - https://github.com/zombocom/derailed_benchmarks/blob/v2.2.1/lib/derailed_benchmarks/require_tree.rb#L53
#
require "bundler/setup"

require "get_process_mem"

mem = GetProcessMem.new

before = mem.mb

require "convenient_service"

after = mem.mb

puts "#{(after - before).round(4)} MiB"
