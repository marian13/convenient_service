# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Method
      module Name
        class Append < Support::Command
          ##
          # @!attribute [r] method_name
          #   @return [String, Symbol]
          #
          attr_reader :method_name

          ##
          # @!attribute [r] method_suffix
          #   @return [String, Symbol]
          #
          attr_reader :method_suffix

          ##
          # @param method_name [String, Symbol]
          # @param method_suffix [String, Symbol]
          # @return [void]
          #
          def initialize(method_name, method_suffix)
            @method_name = method_name.to_s
            @method_suffix = method_suffix.to_s
          end

          ##
          # @return [String]
          #
          def call
            return "" if method_name.empty?

            if method_name.end_with?("!")
              "#{method_name.delete_suffix("!")}#{method_suffix}!"
            elsif method_name.end_with?("?")
              "#{method_name.delete_suffix("?")}#{method_suffix}?"
            else
              "#{method_name}#{method_suffix}"
            end
          end
        end
      end
    end
  end
end
