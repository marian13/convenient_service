# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      module Concerns
        class ConcernMiddleware
          attr_reader :stack

          def initialize(stack)
            @stack = stack
          end

          def call(env)
            env[:entity].include concern

            stack.call(env)
          end

          private

          ##
          # NOTE: `self.class.concern' is overridden by descendants. Descendants are created dynamically. See `Concerns::MiddlewareStack#cast'.
          #
          # IMPORTANT: Must be kept in sync with `cast' in `ConvenientService::Core::Entities::Concerns::MiddlewareStack'.
          #
          def concern
            self.class.concern
          end

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
end
