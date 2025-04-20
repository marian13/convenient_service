# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "type/concern"

module ConvenientService
  module Common
    module Plugins
      module CanHaveCallbacks
        module Entities
          class Type
            include Support::Castable
            include Support::Delegate

            include Concern

            ##
            # @!attribute [r] value
            #   @return [Symbol]
            #
            attr_reader :value

            ##
            # @param value [Symbol]
            # @return [void]
            #
            def initialize(value:)
              @value = value
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if value != other.value

              true
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            # @internal
            #   NOTE: Used by `contain_exactly`. Check its specs.
            #
            #   NOTE: This method is intented to be used only for hash keys comparison,
            #   when you know for sure that `other` is always an `Entities::Type` instance.
            #
            #   IMPORTANT: Do NOT use `eql?` without a strong reason, prefer `==`.
            #
            #   IMPORTANT: Do NOT delegate to `==` from `eql?`. When user overrides `==` then it can break `eql?`.
            #   - https://shopify.engineering/implementing-equality-in-ruby
            #   - https://github.com/ruby/ruby/blob/v3_3_0/hash.c#L3719
            #   - https://belighted.com/blog/overriding-equals-equals
            #
            def eql?(other)
              return unless other.instance_of?(self.class)

              return false if value != other.value

              true
            end

            ##
            # @return [Integer]
            #
            # @internal
            #   NOTE: Common way to implement hash.
            #   - https://shopify.engineering/implementing-equality-in-ruby
            #
            def hash
              [self.class, value].hash
            end
          end
        end
      end
    end
  end
end
