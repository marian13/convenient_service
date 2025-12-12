# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Object
      ##
      # @api private
      # @since 1.0.0
      # @example Common usage.
      #   ConvenientService::Utils::Object::ResolveType.call("foo")
      #   # => "instance"
      #
      #   ConvenientService::Utils::Object::ResolveType.call(Array)
      #   # => "class"
      #
      #   ConvenientService::Utils::Object::ResolveType.call(Kernel)
      #   # => "module"
      #
      class ResolveType < Support::Command
        ##
        # @!attribute [r] object
        #   @return [Object] Can be any type.
        #
        attr_reader :object

        ##
        # @param object [Object] Can be any type.
        #
        def initialize(object)
          @object = object
        end

        ##
        # @return ["class", "module", "instance"]
        #
        def call
          case object
          when ::Class
            "class"
          when ::Module
            "module"
          else
            "instance"
          end
        end
      end
    end
  end
end
