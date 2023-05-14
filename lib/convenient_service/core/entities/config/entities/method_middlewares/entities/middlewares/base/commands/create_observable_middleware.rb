# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                class Base
                  module Commands
                    class CreateObservableMiddleware < Support::Command
                      ##
                      # @!attribute [r] middleware
                      #   @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                      #
                      attr_reader :middleware

                      ##
                      # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                      # @return [void]
                      #
                      def initialize(middleware:)
                        @middleware = middleware
                      end

                      ##
                      # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                      #
                      def call
                        observable_middleware.class_exec(middleware) do |middleware|
                          ##
                          # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                          #
                          define_singleton_method(:middleware) { middleware }

                          ##
                          # @param other [Object] Can be any type.
                          # @return [Boolean, nil]
                          #
                          define_singleton_method(:==) { |other| self.middleware == other.middleware if other.respond_to?(:middleware) }

                          ##
                          # @return [String]
                          #
                          define_singleton_method(:inspect) { "Observable(#{middleware})" }
                        end

                        observable_middleware
                      end

                      private

                      ##
                      # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                      #
                      def observable_middleware
                        @observable_middleware ||=
                          ::Class.new(middleware) do
                            ##
                            # @param stack [#call<Hash>]
                            # @param kwargs [Hash{Symbol => Object}]
                            # @return [void]
                            #
                            def initialize(stack, **kwargs)
                              arguments = Support::Arguments.new(stack, **Utils::Hash.except(kwargs, [:events]))

                              @__events__ = kwargs[:events]

                              @__events__[:before_initialize].notify_observers(arguments)

                              super(stack, **arguments.kwargs)

                              @__events__[:after_initialize].notify_observers(arguments)
                            end

                            ##
                            # @return [Object] Can be any type.
                            #
                            def call(...)
                              arguments = Support::Arguments.new(...)

                              @__events__[:before_call].notify_observers(arguments)

                              value = super

                              @__events__[:after_call].notify_observers(value, arguments)

                              value
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
      end
    end
  end
end
