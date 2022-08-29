# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class ClassicMiddleware
        attr_reader :stack

        def initialize(stack)
          @stack = stack
        end

        # rubocop:disable Rails/Delegate
        def call(env)
          stack.call(env)
        end
        # rubocop:enable Rails/Delegate

        ##
        # TODO: Unify `inspect'. Specs for `inspect'.
        #
        def inspect
          self.class.inspect
        end
      end
    end
  end
end
