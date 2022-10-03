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
                        original_method =
                          if self.is_a?(Class)
                            self.commit_config!

                            proc do |env|
                              self.singleton_class
                                .ancestors
                                .then { |ancestors| ConvenientService::Utils::Array.drop_while(ancestors, inclusively: true) { |ancestor| ancestor != self::ClassMethodsMiddlewaresCallers } }
                                .find { |ancestor| ConvenientService::Utils::Module.respond_to_own?(ancestor, method, private: true) }
                                .instance_method(method)
                                .bind(self)
                                .call(*env[:args], **env[:kwargs], &env[:block])
                            end
                          else
                            self.class.commit_config!

                            proc do |env|
                              # byebug if self.class == ConvenientService::Examples::Standard::Gemfile::Services::RunShell

                              self.class
                                .ancestors
                                .then { |ancestors| ConvenientService::Utils::Array.drop_while(ancestors, inclusively: true) { |ancestor| ancestor != self.class::InstanceMethodsMiddlewaresCallers } }
                                .find { |ancestor| ConvenientService::Utils::Module.respond_to_own?(ancestor, method, private: true) }
                                .then { |mod| ConvenientService::Utils::Method.find_own_from_class(method, mod) }
                                .bind(self)
                                .call(*env[:args], **env[:kwargs], &env[:block])
                            end
                          end

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
