# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Module
      ##
      # Returns constant defined directly in `mod`.
      #
      # @api private
      # @since 1.0.0
      #
      # @example Common usage.
      #   module Test
      #   end
      #
      #   ConvenientService::Utils::Module::GetOwnConst.call(Test, :File)
      #   # => nil, not File from Ruby Core.
      #
      #   module Test
      #     class File
      #     end
      #   end
      #
      #   ConvenientService::Utils::Module::GetOwnConst.call(Test, :File)
      #   # => Test::File
      #
      class GetOwnConst < Support::Command
        ##
        # @!attribute [r] mod
        #   @return [Class, Module]
        #
        attr_reader :mod

        ##
        # @!attribute [r] const_name
        #   @return [Symbol]
        #
        attr_reader :const_name

        ##
        # @param mod [Class, Module]
        # @param const_name [Symbol]
        # @return [void]
        #
        def initialize(mod, const_name)
          @mod = mod
          @const_name = const_name
        end

        ##
        # @return [Object] Value of own const. Can be any type.
        #
        def call
          ##
          # NOTE: > If `inherit` is `false`, the lookup only checks the constants in the receiver:
          # https://ruby-doc.org/core-3.0.0/Module.html#method-i-const_defined-3F
          #
          return unless mod.const_defined?(const_name, false)

          mod.const_get(const_name, false)
        end
      end
    end
  end
end
