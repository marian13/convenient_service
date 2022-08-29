# frozen_string_literal: true

module ConvenientService
  module Core
    module Commands
      class AssertConcernMiddlewareStackNotFixed < Support::Command
        attr_reader :stack

        def initialize(stack:)
          @stack = stack
        end

        def call
          return unless stack.called?

          raise Errors::ConcernMiddlewareStackIsFixed.new(stack: stack)
        end
      end
    end
  end
end
