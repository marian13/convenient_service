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

                ##
                # @!attribute [r] scope
                #   @return [:instance, :class]
                #
                attr_reader :scope

                ##
                # @!attribute [r] method
                #   @return [String, Symbol]
                #
                attr_reader :method

                ##
                # @!attribute [r] container
                #   @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                #
                attr_reader :container

                ##
                # @return [void]
                #
                delegate :prepend_methods_middlewares_callers_to_container, to: :container

                ##
                # @return [Module]
                #
                delegate :methods_middlewares_callers, to: :container

                ##
                # @param method [String, Symbol]
                # @param container [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                # @return [void]
                #
                def initialize(scope:, method:, container:)
                  @scope = scope
                  @method = method
                  @container = container
                end

                ##
                # @return [Boolean] true if method middlewares caller is just defined, false if already defined.
                #
                def call
                  return false if Utils::Method.defined?(method, methods_middlewares_callers, private: true)

                  prepend_methods_middlewares_callers_to_container

                  define_method_middlewares_caller

                  true
                end

                private

                ##
                # @return [void]
                #
                # @internal
                #   NOTE: Assignment of `scope` and `method` in the beginning for easier debugging.
                #
                #   NOTE: Check the following link in order to get an idea why two versions of `define_method_middlewares_caller` exist.
                #   https://gist.github.com/marian13/9c25041f835564e945d978839097d419
                #
                if ::RUBY_VERSION >= "3.0"
                  def define_method_middlewares_caller
                    <<~RUBY.tap { |code| methods_middlewares_callers.module_eval(code, __FILE__, __LINE__ + 1) }
                      def #{method}(*args, **kwargs, &block)
                        method = :#{method}
                        scope = :#{scope}

                        method_middlewares = middlewares(method, scope: scope)

                        env = {args: args, kwargs: kwargs, block: block, entity: self}
                        original_method = proc { |env| super(*env[:args], **env[:kwargs], &env[:block]) }

                        method_middlewares.call(env, original_method)
                      end
                    RUBY
                  end
                else
                  def define_method_middlewares_caller
                    <<~RUBY.tap { |code| methods_middlewares_callers.module_eval(code, __FILE__, __LINE__ + 1) }
                      def #{method}(*args, **kwargs, &block)
                        method = :#{method}
                        scope = :#{scope}

                        method_middlewares = middlewares(method, scope: scope)

                        env = {args: args, kwargs: kwargs, block: block, entity: self}
                        super_method = method_middlewares.resolve_super_method(self)
                        original_method = proc { |env| super_method.call(*env[:args], **env[:kwargs], &env[:block]) }

                        raise ::NoMethodError, method_middlewares.no_super_method_exception_message_for(self) unless super_method

                        method_middlewares.call(env, original_method)
                      end
                    RUBY
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
