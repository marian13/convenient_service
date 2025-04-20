# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
