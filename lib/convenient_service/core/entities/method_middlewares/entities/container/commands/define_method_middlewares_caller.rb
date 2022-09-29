# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Container
            module Commands
              class DefineMethodMiddlewaresCaller < Support::Command
                include Support::Delegate

                attr_reader :scope, :method, :container

                def initialize(scope:, method:, container:)
                  @scope = scope
                  @method = method
                  @container = container
                end

                ##
                # @return [Boolean] true if method middlewares caller is just defined, false if already defined.
                #
                def call
                  return false if Utils::Method.defined?(method, in: methods_middlewares_callers)

                  prepend_methods_middlewares_callers_to_container

                  ##
                  # NOTE: Assignment in the beginning for easier debugging.
                  #
                  <<~RUBY.tap { |code| methods_middlewares_callers.module_eval(code, __FILE__, __LINE__ + 1) }
                    def #{method}(*args, **kwargs, &block)
                      scope = :#{scope}
                      method = :#{method}

                      env = {entity: self, args: args, kwargs: kwargs, block: block}
                      original = proc { |env| super(*env[:args], **env[:kwargs], &env[:block]) }

                      middlewares(for: method, scope: scope).call(env, original)
                    end
                  RUBY

                  true
                end

                private

                ##
                # @return [Module]
                #
                def methods_middlewares_callers
                  @methods_middlewares_callers ||= container.resolve_methods_middlewares_callers(scope)
                end

                def prepend_methods_middlewares_callers_to_container
                  Commands::PrependModule.call(scope: scope, container: container, mod: methods_middlewares_callers)
                end
              end
            end
          end
        end
      end
    end
  end
end
