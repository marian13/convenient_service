# frozen_string_literal: true

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
            # @return [Integer]
            #
            delegate :hash, to: :value

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
            def eql?(other)
              return unless other.instance_of?(self.class)

              hash == other.hash
            end
          end
        end
      end
    end
  end
end
