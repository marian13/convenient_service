# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Object
      class InstanceVariableDelete < Support::Command
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
        # @param object [Object]
        # @param ivar_name [Symbol]
        # @return [void]
        #
        def initialize(object, ivar_name)
          @object = object
          @ivar_name = ivar_name
        end

        ##
        # @return [Object] Value of ivar. Can be any type.
        #
        def call
          object.remove_instance_variable(ivar_name) if object.instance_variable_defined?(ivar_name)
        end
      end
    end
  end
end
