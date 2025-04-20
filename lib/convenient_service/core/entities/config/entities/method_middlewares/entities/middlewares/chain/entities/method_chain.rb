# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                ##
                # @abstract Subclass and override `#next`.
                #
                # @internal
                #   NOTE: Do NOT pollute the interface of this class until really needed.
                #   Avoid even pollution of private methods.
                #   This way there is a lower risk that a plugin developer accidentally overwrites an internal middleware behavior.
                #   https://github.com/Ibsciss/ruby-middleware#a-basic-example
                #
                class Chain < Middlewares::Base
                  module Entities
                    ##
                    # @internal
                    #   NOTE: Do NOT pollute the interface of this class until really needed.
                    #
                    class MethodChain
                      ##
                      # @param stack [#call<Hash>]
                      # @param env [Hash]
                      # @return [void]
                      #
                      def initialize(stack:, env: {})
                        @stack = stack
                        @env = env
                      end

                      ##
                      # @param args [Array<Object>]
                      # @param kwargs [Hash{Symbol => Object}]
                      # @param block [Proc, nil]
                      # @return [Object] Can be any type.
                      #
                      # @internal
                      #   TODO: Enforce to always pass args, kwargs, block.
                      #
                      def next(*args, **kwargs, &block)
                        stack.call(env.merge(args: args, kwargs: kwargs, block: block))
                      end

                      ##
                      # @param other [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Chain, Object]
                      # @return [Boolean]
                      #
                      def ==(other)
                        return unless other.instance_of?(self.class)

                        return false if stack != other.stack
                        return false if env != other.env

                        true
                      end

                      protected

                      ##
                      # @!attribute [r] stack
                      #   @return [#call<Hash>]
                      #
                      attr_reader :stack

                      ##
                      # @!attribute [r] env
                      #   @return [Hash]
                      #
                      attr_reader :env
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
