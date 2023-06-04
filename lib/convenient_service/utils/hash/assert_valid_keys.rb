# frozen_string_literal: true

##
# @example:
#   ConvenientService::Utils::Hash::AssertValidKeys.call({foo: "foo", bar: "bar"}, [:foo, :bar])
#
module ConvenientService
  module Utils
    module Hash
      class AssertValidKeys < Support::Command
        ##
        # @!attribute [r] hash
        #   @return [Hash]
        #
        attr_reader :hash

        ##
        # @!attribute [r] valid_keys
        #   @return [Array]
        #
        attr_reader :valid_keys

        ##
        # @param hash [Hash]
        # @param valid_keys [Array]
        # @return [void]
        #
        def initialize(hash, valid_keys)
          @hash = hash
          @valid_keys = valid_keys.flatten
        end

        ##
        # @return [Hash]
        #
        # @internal
        #   NOTE: Copied with minimal modifications from:
        #   https://api.rubyonrails.org/classes/Hash.html#method-i-assert_valid_keys
        #
        def call
          hash.each_key do |key|
            next if valid_keys.include?(key)

            raise ::ArgumentError.new("Unknown key: #{key.inspect}. Valid keys are: #{valid_keys.map(&:inspect).join(", ")}")
          end
        end
      end
    end
  end
end
