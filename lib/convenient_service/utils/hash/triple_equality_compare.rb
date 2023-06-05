# frozen_string_literal: true

module ConvenientService
  module Utils
    module Hash
      class TripleEqualityCompare < Support::Command
        ##
        # @!attribute [r] hash
        #   @return [Hash]
        #
        attr_reader :hash

        ##
        # @!attribute [r] other_hash
        #   @return [Array]
        #
        attr_reader :other_hash

        ##
        # @param hash [Hash]
        # @param other_hash [Hash]
        # @return [void]
        #
        def initialize(hash, other_hash)
          @hash = hash
          @other_hash = other_hash
        end

        ##
        # @return [Boolean]
        #
        def call
          return false if hash.keys.difference(other_hash.keys).any?

          return false unless hash.all? { |key, value| value === other_hash[key] }

          true
        end
      end
    end
  end
end
