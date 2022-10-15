# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class ClassicMiddleware
        ##
        # @param stack [#call<Hash>]
        # @return [void]
        #
        def initialize(stack)
          @stack = stack
        end

        ##
        # @return [Object] Can be any type.
        #
        def call(env)
          stack.call(env)
        end

        private

        ##
        # @!attribute [r] stack
        #   @return [#call<Hash>]
        #
        attr_reader :stack
      end
    end
  end
end
