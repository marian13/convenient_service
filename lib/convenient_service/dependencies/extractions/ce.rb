# frozen_string_literal: true

##
# @note `ce` is short for `catch_exception`.
#
# @example
#   ce { some_code }
#   e = ce { some_code }
#
def ce
  yield

  nil
rescue => exception
  exception
end
