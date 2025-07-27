# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Works in a similar way as `p`, but for `byebug`.
# @see https://ruby-doc.org/core-2.7.0/Kernel.html#method-i-p
#
def b(*args)
  require "byebug"
  require "byebug/core"

  ::Byebug.attach

  args.one? ? args.first : args
end
