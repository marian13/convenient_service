# frozen_string_literal: true

##
# Works in a similar way as `p`, but for `binding.break`.
# @see https://ruby-doc.org/core-2.7.0/Kernel.html#method-i-p
# @see https://github.com/ruby/debug/blob/v1.10.0/lib/debug/prelude.rb#L11
#
def bb(*args)
  require "debug"

  binding.break(up_level: 2)

  args.one? ? args.first : args
end
