# frozen_string_literal: true

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
          THREAD_SAFE_ARRAY = :thread_safe_array

          ##
          # @return [Array<Symbol>]
          #
          ALL = [ARRAY, HASH, THREAD_SAFE_ARRAY]

          ##
          # @return [Symbol]
          #
          DEFAULT = HASH
        end
      end
    end
  end
end
