# frozen_string_literal: true

require_relative "array/pair"

module ConvenientService
  module Support
    class Cache
      class Constants
        module Backends
          ##
          # @return [Symbol]
          #
          ARRAY = :array

          ##
          # @return [Symbol]
          #
          HASH = :hash

          ##
          # @return [Symbol]
          #
          ALL = [ARRAY, HASH]

          ##
          # @return [Symbol]
          #
          DEFAULT = HASH
        end
      end
    end
  end
end
