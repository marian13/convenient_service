# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    class Cache
      module Constants
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
          # @return [Symbol]
          #
          THREAD_SAFE_HASH = :thread_safe_hash

          ##
          # @return [Array<Symbol>]
          #
          ALL = [ARRAY, HASH, THREAD_SAFE_ARRAY, THREAD_SAFE_HASH]

          ##
          # @return [Symbol]
          #
          DEFAULT = HASH
        end
      end
    end
  end
end
