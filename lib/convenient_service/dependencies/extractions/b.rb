# frozen_string_literal: true

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
