# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

puts "TIP: Comment `return` in `lib/convenient_service/debug/timeout.rb` to debug `Timeout.timeout`."

return

##
# @internal
#   - https://github.com/ruby/ruby/blob/v2_7_0/lib/timeout.rb#L77
#   - https://github.com/ruby/ruby/blob/v2_7_8/lib/timeout.rb#L77
#
if ConvenientService::Dependencies.ruby.version >= 2.7 && ConvenientService::Dependencies.ruby.version < 3.0
  puts "[ConvenientService][Timeout]: Redefined `Timeout.timeout` for debugging."

  require "timeout"

  module Timeout
    def timeout(sec, klass = nil, message = nil)   #:yield: +sec+
      return yield(sec) if sec == nil or sec.zero?
      message ||= "execution expired".freeze
      from = "from #{caller_locations(1, 1)[0]}" if $DEBUG
      e = Error
      bl = proc do |exception|
        begin
          x = Thread.current
          y = Thread.start {
            puts "[ConvenientService][Timeout]: Start timeout thread `#{Thread.current.object_id}`."

            Thread.current.name = from
            begin
              sleep sec
            rescue => e
              puts "[ConvenientService][Timeout]: End timeout thread `#{Thread.current.object_id}` by rescue."

              x.raise e
            else
              puts "[ConvenientService][Timeout]: End timeout thread `#{Thread.current.object_id}` by else."

              x.raise exception, message
            end
          }
          return yield(sec)
        ensure
          if y
            puts "[ConvenientService][Timeout]: End timeout thread `#{y.object_id}` by kill."

            y.kill
            y.join # make sure y is dead.
          end
        end
      end
      if klass
        begin
          bl.call(klass)
        rescue klass => e
          bt = e.backtrace
        end
      else
        bt = Error.catch(message, &bl)
      end
      level = -caller(CALLER_OFFSET).size-2
      while THIS_FILE =~ bt[level]
        bt.delete_at(level)
      end
      raise(e, message, bt)
    end

    module_function :timeout
  end
end
