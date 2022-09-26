# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class ClassicMiddleware
        attr_reader :stack

        def initialize(stack)
          @stack = stack
        end

        def call(env)
          stack.call(env)
        end

        ##
        # TODO: Unify `inspect`. Specs for `inspect`.
        #
        def inspect
          self.class.inspect
        end
      end
    end
  end
end
