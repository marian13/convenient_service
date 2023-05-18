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
                      def initialize(stack, **kwargs)
                        @__stack__ = stack
                        @__env__ = kwargs.fetch(:env) { {} }
                        @__arguments__ = kwargs.fetch(:arguments) { Support::Arguments.null_arguments }
                      end

                      ##
                      # @return [ConvenientService::Support::Arguments]
                      #
                      def arguments
                        @__arguments__
                      end

                      ##
                      # @param other [Object] Can be any type.
                      # @return [Boolean, nil]
                      #
                      def ==(other)
                        return unless other.instance_of?(self.class)

                        return false if @__stack__ != other.instance_variable_get(:@__stack__)
                        return false if @__env__ != other.instance_variable_get(:@__env__)
                        return false if @__arguments__ != other.instance_variable_get(:@__arguments__)

                        true
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
