# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: Idea for trapping custom Linux signal is taken from:
# - https://github.com/rspec/rspec-rails/issues/1353#issuecomment-93173691
# - https://superuser.com/questions/1607829/what-does-kill-usr1-1-do
#
# NOTE: `USR1` is already used by JRuby.
#
# NOTE: Usage example with Docker.
#
#   Docker container starts specs process and prints pid.
#   $ RUBY_ENGINE=ruby RUBY_ENGINE_VERSION=2.7 task docker:bash
#   # task test
#
#   Other terminal session is opened in the same Docker container.
#   $ docker ps -a
#   $ docker exec -it <container_id> /bin/sh
#   # kill -USR2 <rspec_pid>
##

puts "RSpec pid: `#{Process.pid}`."

puts "TIP: Run `kill -USR2 #{Process.pid}` from other terminal (container) session to print all thread backtraces in case RSpec is stuck."

trap "USR2" do
  require "io/console"

  terminal_width = IO.console.winsize.last
  terminal_border = "-" * terminal_width

  threads = Thread.list

  puts
  puts terminal_border
  puts "Received `USR2` signal. Printing all `#{threads.count}` thread backtraces."

  threads.each do |thread|
    description = (thread == Thread.main) ? "main" : thread.inspect
    backtrace = thread.backtrace.to_a

    puts
    puts "#{description} backtrace: "
    puts backtrace.empty? ? "Empty backtrace." : backtrace.join("\n")
  end

  puts terminal_border
end
