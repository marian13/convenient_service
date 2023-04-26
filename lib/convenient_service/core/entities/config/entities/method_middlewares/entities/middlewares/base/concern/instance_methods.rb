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
                    module InstanceMethods
                      include Support::AbstractMethod

                      ##
                      # @return [Object] Can be any type.
                      #
                      abstract_method :call

                      ##
                      # @param stack [#call<Hash>]
                      # @return [void]
                      #
                      def initialize(stack, env: {}, arguments: Support::Arguments.null_arguments)
                        @__stack__ = stack
                        @__env__ = env
                        @__arguments__ = arguments
                      end

                      ##
                      # @return [ConvenientService::Support::Arguments]
                      #
                      def arguments
                        @__arguments__
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
