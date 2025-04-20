# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
#
#
module ConvenientService
  module Utils
    module Object
      ##
      # Can be used instead of `return @ivar if defined? @ivar`.
      # @see https://www.justinweiss.com/articles/4-simple-memoization-patterns-in-ruby-and-one-gem/
      #
      class InstanceVariableFetch < Support::Command
        ##
        # @!attribute [r] object
        #   @return [Object]
        #
        attr_reader :object

        ##
        # @!attribute [r] ivar_name
        #   @return [Symbol, String]
        #
        attr_reader :ivar_name

        ##
        # @!attribute [r] fallback_block
        #   @return [Proc, nil]
        #
        attr_reader :fallback_block

        ##
        # @param object [Object]
        # @param ivar_name [Symbol]
        # @param fallback_block [Proc]
        # @return [void]
        #
        def initialize(object, ivar_name, &fallback_block)
          @object = object
          @ivar_name = ivar_name
          @fallback_block = fallback_block
        end

        ##
        # @return [Object] Value of ivar. Can be any type.
        #
        def call
          return object.instance_variable_get(ivar_name) if object.instance_variable_defined?(ivar_name)

          return object.instance_variable_set(ivar_name, fallback_block.call) if fallback_block

          nil
        end
      end
    end
  end
end
