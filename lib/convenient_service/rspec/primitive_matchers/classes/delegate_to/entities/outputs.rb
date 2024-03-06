# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            class Outputs
              ##
              # @api private
              #
              # @return [Array]
              #
              def delegations
                @delegations ||= []
              end

              ##
              # @api private
              #
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if delegations != other.delegations

                true
              end
            end
          end
        end
      end
    end
  end
end
