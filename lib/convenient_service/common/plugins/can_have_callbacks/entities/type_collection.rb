# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module CanHaveCallbacks
        module Entities
          class TypeCollection
            ##
            # @!attribute [r] types
            #   @return [Array<Symbol>]
            #
            attr_reader :types

            ##
            # @param types [Array<Symbol>]
            # @return [void]
            #
            def initialize(types:)
              @types = types.map(&Entities::Type.method(:cast!))
            end

            ##
            # @param other_types [Array<Object>]
            # @return [Boolean]
            #
            def contain_exactly?(other_types)
              other_types = other_types.map(&Entities::Type.method(:cast!))

              Utils::Array.contain_exactly?(types, other_types)
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if types != other.types

              true
            end
          end
        end
      end
    end
  end
end
