# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
