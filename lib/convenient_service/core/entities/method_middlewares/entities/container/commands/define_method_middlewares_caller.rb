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

                  define_method

                  true
                end

                private

                ##
                # @return [void]
                #
                # @internal
                #   NOTE: Assignment of `scope` and `method` in the beginning for easier debugging.
                #
                if ::RUBY_VERSION >= "3.0"
                  def define_method
                    <<~RUBY.tap { |code| methods_middlewares_callers.module_eval(code, __FILE__, __LINE__ + 1) }
                      def #{method}(*args, **kwargs, &block)
                        scope = :#{scope}
                        method = :#{method}

                        env = {entity: self, args: args, kwargs: kwargs, block: block}
                        original_method = proc { |env| super(*env[:args], **env[:kwargs], &env[:block]) }

                        middlewares(method: method, scope: scope).call(env, original_method)
                      end
                    RUBY
                  end
                else
                  ##
                  # @see https://gist.github.com/marian13/9c25041f835564e945d978839097d419
                  #
                  def define_method
                    <<~RUBY.tap { |code| methods_middlewares_callers.module_eval(code, __FILE__, __LINE__ + 1) }
                      def #{method}(*args, **kwargs, &block)
                        scope = :#{scope}
                        method = :#{method}

                        env = {entity: self, args: args, kwargs: kwargs, block: block}

                        ##
                        # NOTE: Full namespace should specified all the time, e.g: `ConvenientService::...`),
                        # since this method is called in the context of the end user code.
                        #
                        super_method = ConvenientService::Core::Entities::MethodMiddlewares::Entities::Caller.resolve_super_method(self, scope, method)

                        original_method = proc { |env| super_method.call(*env[:args], **env[:kwargs], &env[:block]) }

                        middlewares(method: method, scope: scope).call(env, original_method)
                      end
                    RUBY
                  end
                end

                ##
                # @return [Module]
                #
                def methods_middlewares_callers
                  @methods_middlewares_callers ||= container.resolve_methods_middlewares_callers(scope)
                end

                ##
                # @return [void]
                #
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
