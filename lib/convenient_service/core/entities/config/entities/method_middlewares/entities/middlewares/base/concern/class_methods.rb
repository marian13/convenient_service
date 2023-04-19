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
                      # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreator]
                      #
                      def with(...)
                        Entities::MiddlewareCreator.new(middleware: self, arguments: Support::Arguments.new(...))
                      end

                      ##
                      # @return [Array<ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Structs::IntendedMethod>]
                      #
                      # @internal
                      #   TODO: Wrap with `WeakRef` to reduce memory consumption.
                      #
                      def intended_methods
                        @intended_methods ||= []
                      end

                      private

                      ##
                      # @param method [Symbol]
                      # @param scope [Symbol]
                      # @return [Array<ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Structs::IntendedMethod>]
                      #
                      def intended_for(method, scope: :instance)
                        intended_methods << Structs::IntendedMethod.new(method, scope)
                      end

                      ##
                      # @return [ConvenientService::Support::Anything]
                      #
                      def any_method
                        Constants::ANY_METHOD
                      end

                      ##
                      # @return [ConvenientService::Support::Anything]
                      #
                      def any_scope
                        Constants::ANY_SCOPE
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
