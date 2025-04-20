# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# - https://github.com/rspec/rspec-rails/issues/1353#issuecomment-93173691
# - https://superuser.com/questions/1607829/what-does-kill-usr1-1-do
#
puts "RSpec pid: `#{Process.pid}`."

##
# Usage example with Docker.
#
#   Docker container starts specs process and prints pid.
#   $ RUBY_ENGINE=ruby RUBY_ENGINE_VERSION=2.7 task docker:bash
#   # task test
#
#   Other terminal session is opened in the same Docker container.
#   $ docker ps -a
#   $ docker exec -it <container_id> /bin/sh
#   # kill -USR1 <rspec_pid>
#
puts "TIP: Run `kill -USR1 #{Process.pid}` from other terminal (container) session to print all thread backtraces in case RSpec is stuck."

trap "USR1" do
  threads = Thread.list

  puts
  puts "=" * 80
  puts "Received USR1 signal. Printing all `#{threads.count}` thread backtraces."

  threads.each do |thr|
    description = (thr == Thread.main) ? "Main thread" : thr.inspect

    puts
    puts "#{description} backtrace: "
    puts thr.backtrace.join("\n")
  end

  puts "=" * 80
end
