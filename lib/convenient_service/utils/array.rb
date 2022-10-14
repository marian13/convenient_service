# frozen_string_literal: true

require_relative "array/errors"

require_relative "array/contain_exactly"
require_relative "array/drop_while"
require_relative "array/find_last"
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

        def merge(...)
          Merge.call(...)
        end

        def rjust(...)
          RJust.call(...)
        end

        def wrap(...)
          Wrap.call(...)
        end
      end
    end
  end
end
