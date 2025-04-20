# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "array/exceptions"

require_relative "array/contain_exactly"
require_relative "array/drop_while"
require_relative "array/find_last"
require_relative "array/find_yield"
require_relative "array/keep_after"
require_relative "array/limited_push"
require_relative "array/merge"
require_relative "array/rjust"
require_relative "array/wrap"

module ConvenientService
  module Utils
    module Array
      class << self
        def contain_exactly?(...)
          ContainExactly.call(...)
        end

        def drop_while(...)
          DropWhile.call(...)
        end

        def find_last(...)
          FindLast.call(...)
        end

        def find_yield(...)
          FindYield.call(...)
        end

        def keep_after(...)
          KeepAfter.call(...)
        end

        def limited_push(...)
          LimitedPush.call(...)
        end

        def merge(...)
          Merge.call(...)
        end

        def rjust(...)
          Rjust.call(...)
        end

        def wrap(...)
          Wrap.call(...)
        end
      end
    end
  end
end
