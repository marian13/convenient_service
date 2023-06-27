# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                ##
                # @abstract Subclass and override `#call`.
                #
                # @internal
                #   NOTE: Do NOT pollute the interface of this class until really needed.
                #   Avoid even pollution of private methods.
                #   This way there is a lower risk that a plugin developer accidentally overwrites an internal middleware behavior.
                #   https://github.com/Ibsciss/ruby-middleware#a-basic-example
                #
                class Base
                  module Concern
                    module ClassMethods
                      ##
                      # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::With]
                      #
                      def with(...)
                        Entities::MiddlewareCreators::With.new(middleware: self, middleware_arguments: Support::Arguments.new(...))
                      end

                      ##
                      # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable]
                      #
                      def observable
                        Entities::MiddlewareCreators::Observable.new(middleware: self)
                      end

                      ##
                      # @return [Hash{Symbol => Object}]
                      #
                      def extra_kwargs
                        {}
                      end

                      ##
                      # @return [Array<ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Structs::IntendedMethod>]
                      #
                      # @internal
                      #   TODO: Consider to wrap with `WeakRef` to reduce memory consumption.
                      #
                      def intended_methods
                        @intended_methods ||= []
                      end

                      ##
                      # @return [Class]
                      #
                      def to_observable_middleware
                        Commands::CreateObservableMiddleware.call(middleware: self)
                      end

                      private

                      ##
                      # @param method [Symbol]
                      # @param scope [Symbol, ConvenientService::Support::UniqueValue]
                      # @param entity [Symbol, ConvenientService::Support::UniqueValue]
                      # @return [Array<ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Structs::IntendedMethod>]
                      #
                      # @internal
                      #   TODO: Direct specs.
                      #
                      def intended_for(method, entity:, scope: :instance)
                        intended_methods << Structs::IntendedMethod.new(method, scope, entity)
                      end

                      ##
                      # @return [ConvenientService::Support::UniqueValue]
                      #
                      # @internal
                      #   TODO: Direct specs.
                      #
                      def any_method
                        Constants::ANY_METHOD
                      end

                      ##
                      # @return [ConvenientService::Support::UniqueValue]
                      #
                      # @internal
                      #   TODO: Direct specs.
                      #
                      def any_scope
                        Constants::ANY_SCOPE
                      end

                      ##
                      # @return [ConvenientService::Support::UniqueValue]
                      #
                      # @internal
                      #   TODO: Direct specs.
                      #
                      def any_entity
                        Constants::ANY_ENTITY
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
