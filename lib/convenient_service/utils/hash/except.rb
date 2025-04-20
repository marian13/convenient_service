# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# @example
#   ConvenientService::Utils::Hash::Except.call({foo: :bar, baz: :qux}, [:foo])
#
module ConvenientService
  module Utils
    module Hash
      class Except < Support::Command
        ##
        # @!attribute [r] hash
        #   @return [Hash]
        #
        attr_reader :hash

        ##
        # @!attribute [r] keys
        #   @return [Array]
        #
        attr_reader :keys

        ##
        # @param hash [Hash]
        # @param keys [Array]
        # @return [void]
        #
        def initialize(hash, keys)
          @hash = hash
          @keys = keys
        end

        ##
        # @return [Hash]
        #
        # @internal
        #   NOTE: Copied with minimal modifications from:
        #   https://api.rubyonrails.org/classes/Hash.html#method-i-except
        #
        def call
          hash.slice(*hash.keys - keys)
        end
      end
    end
  end
end
