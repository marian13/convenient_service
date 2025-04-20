# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# @example Two args form (works as GetOwnConst).
#   module Test
#   end
#
#   ConvenientService::Utils::Module::FetchOwnConst.call(Test, :File)
#   # => nil, not File from Ruby Core.
#
#   module Test
#     class File
#     end
#   end
#
#   ConvenientService::Utils::Module::FetchOwnConst.call(Test, :File)
#   # => Test::File
#
# @example Two args + block form.
#   module Test
#   end
#
#   ConvenientService::Utils::Module::FetchOwnConst.call(Test, :File) { Class.new }
#   # => Test::File, just created.
#
#   module Test
#     class File
#     end
#   end
#
#   ConvenientService::Utils::Module::FetchOwnConst.call(Test, :File)
#   # => Test::File, already existing.
#
module ConvenientService
  module Utils
    module Module
      class FetchOwnConst < Support::Command
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
        # @!attribute [r] fallback_block
        #   @return [Proc, nil]
        #
        attr_reader :fallback_block

        ##
        # @param mod [Class, Module]
        # @param const_name [Symbol]
        # @param fallback_block [Proc]
        # @return [void]
        #
        def initialize(mod, const_name, &fallback_block)
          @mod = mod
          @const_name = const_name
          @fallback_block = fallback_block
        end

        ##
        # @return [Object] Value of own const. Can be any type.
        #
        # @internal
        #   TODO: Wrap by mutex?
        #
        def call
          ##
          # NOTE: > If `inherit` is `false`, the lookup only checks the constants in the receiver:
          # https://ruby-doc.org/core-3.0.0/Module.html#method-i-const_defined-3F
          #
          return mod.const_get(const_name, false) if mod.const_defined?(const_name, false)

          return mod.const_set(const_name, fallback_block.call) if fallback_block

          nil
        end
      end
    end
  end
end
