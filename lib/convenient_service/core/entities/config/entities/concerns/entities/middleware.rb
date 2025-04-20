# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "middleware/commands"

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class Concerns
            module Entities
              class Middleware
                include Support::Castable

                ##
                # @param stack [#call<Hash>]
                # @return [void]
                #
                def initialize(stack)
                  @stack = stack
                end

                class << self
                  ##
                  # @internal
                  #   TODO: Why regular `include Support::AbstractMethod` does NOT work?.
                  #   NOTE: That is probably happening since the `included` block is evaluated once per hierarchy.
                  #
                  extend Support::AbstractMethod::ClassMethods

                  ##
                  # @return [ConvenientService::Support::Concern, Module]
                  #
                  abstract_method :concern

                  ##
                  # @param other [ConvenientService::Support::Concern, Module]
                  # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware, nil]
                  #
                  def cast(other)
                    Commands::CastMiddleware.call(other: other)
                  end

                  ##
                  # @return [Boolean]
                  #
                  # @internal
                  #   NOTE: `@param other [Module, ConvenientService::Support::Concern, ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware]`
                  #   TODO: How to document `alias_method`?
                  #
                  #   https://ruby-doc.org/core-2.7.0/Module.html#method-i-3D-3D
                  #
                  alias_method :original_two_equals, :==

                  ##
                  # @param other [Module, ConvenientService::Support::Concern, ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware]
                  # @return [Boolean]
                  #
                  # @internal
                  #   https://ruby-doc.org/core-2.7.0/Module.html#method-i-3C
                  #
                  def ==(other)
                    return true if original_two_equals(other)

                    return unless other.instance_of?(Class)
                    return unless other < Entities::Middleware

                    concern == other.concern
                  end

                  ##
                  # @return [String]
                  #
                  def inspect
                    "ConcernMiddleware(#{concern})"
                  end
                end

                ##
                # @param env [Hash]
                # @option env [Class] :klass
                #
                # @return [void]
                #
                def call(env)
                  env[:klass].include concern

                  @stack.call(env)
                end

                ##
                # @return [String]
                #
                # @internal
                #   NOTE: `inspect` must be public. Otherwise `irb` ignores it.
                #
                def inspect
                  "#<ConcernMiddleware(#{concern})>"
                end

                private

                ##
                # @return [Module, ConvenientService::Support::Concern]
                #
                # @internal
                #   NOTE: `self.class.concern` is overridden by descendants. Descendants are created dynamically. See `Concerns::MiddlewareStack#cast`.
                #
                #   IMPORTANT: Must be kept in sync with `cast` in `ConvenientService::Core::Entities::Config::Entities::Concerns::MiddlewareStack`.
                #
                def concern
                  self.class.concern
                end
              end
            end
          end
        end
      end
    end
  end
end
