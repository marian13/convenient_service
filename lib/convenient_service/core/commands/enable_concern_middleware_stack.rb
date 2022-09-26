# frozen_string_literal: true

module ConvenientService
  module Core
    module Commands
      class EnableConcernMiddlewareStack < Support::Command
        attr_reader :stack

        def initialize(stack:)
          @stack = stack
        end

        ##
        # NOTE: Works in a similar way to `require`. If just enabled then returns `true`, if already enabled - returns `false`.
        #
        def call
          return false if stack.called?

          stack.call(entity: stack.entity)

          true
        end
      end
    end
  end
end
