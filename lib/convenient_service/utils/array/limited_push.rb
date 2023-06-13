# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      class LimitedPush < Support::Command
        module Constants
          ##
          # @return [Integer]
          #
          DEFAULT_LIMIT = 1_000
        end

        ##
        # @!attribute [r] array
        #   @return [Array<Object>]
        #
        attr_reader :array

        ##
        # @!attribute [r] object
        #   @return [Object] Can be any type.
        #
        attr_reader :object

        ##
        # @!attribute [r] limit
        #   @return [Integer]
        #
        attr_reader :limit

        ##
        # @param array [Array<Object>]
        # @param object [Object] Can be any type.
        # @return [void]
        #
        def initialize(array, object, limit: Constants::DEFAULT_LIMIT)
          @array = array
          @object = object
          @limit = limit
        end

        ##
        # @return [Array<Object>]
        #
        def call
          return array if array.size >= limit

          array.push(object)
        end
      end
    end
  end
end
