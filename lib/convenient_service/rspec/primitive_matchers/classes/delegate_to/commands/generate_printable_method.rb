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
          module Commands
            class GeneratePrintableMethod < Support::Command
              ##
              # @!attribute [r] object
              #   @return [Object] Can be any type.
              #
              attr_reader :object

              ##
              # @!attribute [r] method
              #   @return [Symbol, String]
              #
              attr_reader :method

              ##
              # @param object [Object] Can by any type.
              # @param method [Symbol, String]
              # @return [void]
              #
              def initialize(object:, method:)
                @object = object
                @method = method
              end

              ##
              # @return [String]
              #
              # @internal
              #   NOTE: `:nocov:` is safe since:
              #   - `ConvenientService::Utils::Object.resolve_type` returns a value from enum.
              #   - All possible enum values have their own `when` branch.
              #
              def call
                case Utils::Object.resolve_type(object)
                when "class", "module"
                  "#{object}.#{method}"
                when "instance"
                  "#{object.class}##{method}"
                else # :nocov:
                end
              end
            end
          end
        end
      end
    end
  end
end
