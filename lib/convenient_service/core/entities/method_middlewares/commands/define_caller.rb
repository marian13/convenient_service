# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Commands
          class DefineCaller < Support::Command
            include Support::Delegate

            attr_reader :stack

            delegate \
              :method,
              :scope,
              :container,
              to: :stack

            def initialize(stack:)
              @stack = stack
            end

            def call
              return if Utils::Method.defined?(method, in: mod)

              ##
              # TODO: `call_with`
              #
              # NOTE: Assignment in the beginning for easier debugging.
              #
              <<~RUBY.tap { |code| mod.class_eval(code, __FILE__, __LINE__ + 1) }
                def #{method}(*args, **kwargs, &block)
                  method = :#{method}

                  scope = :#{scope}

                  env = {entity: self, args: args, kwargs: kwargs, block: block}

                  original = proc { |env| super(*env[:args], **env[:kwargs], &env[:block]) }

                  middlewares(for: method, scope: scope).call(env, original)
                end
              RUBY

              Commands::PrependModule.call(container: container, scope: scope, module: mod)
            end

            private

            def mod
              @mod ||= Commands::ResolvePrependModule.call(container: container, scope: scope)
            end
          end
        end
      end
    end
  end
end
