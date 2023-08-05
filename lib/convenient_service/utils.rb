# frozen_string_literal: true

require_relative "utils/array"
require_relative "utils/bool"
require_relative "utils/class"
require_relative "utils/hash"
require_relative "utils/method"
require_relative "utils/module"
require_relative "utils/proc"
require_relative "utils/string"
require_relative "utils/object"

module ConvenientService
  module Utils
    class << self
      ##
      # @return [Object] Can be any type.
      #
      def memoize_including_falsy_values(...)
        Object::MemoizeIncludingFalsyValues.call(...)
      end

      ##
      # @return [Boolean]
      #
      def to_bool(...)
        Bool::ToBool.call(...)
      end
    end
  end
end
