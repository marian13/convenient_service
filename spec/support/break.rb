# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: `JRUBY_OPTS='--debug'` helps to avoid the follwing warning.
#   /usr/local/bundle/gems/break-0.40.0/lib/break/commands/tracepoint_command.rb:26: warning: tracing (e.g. set_trace_func) will not capture all events without --debug flag
#
# - https://github.com/gsamokovarov/break
# - https://github.com/jruby/jruby/wiki/Environment-Flag
#
puts "TIP: Prefix command with `JRUBY_OPTS='--debug'` in order to debug JRuby code with the `break` gem."
