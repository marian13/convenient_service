# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Array
      class KeepAfter < Support::Command
        ##
        # @!attribute [r] array
        #   @return [Array]
        #
        attr_reader :array

        ##
        # @!attribute [r] object
        #   @return [Object] Can be any type.
        #
        attr_reader :object

        ##
        # @param array [Array]
        # @param object [Object] Can be any type.
        # @return [void]
        #
        def initialize(array, object)
          @array = array
          @object = object
        end

        ##
        # @return [Object, nil] Can be any type.
        # @see https://github.com/rubyworks/facets/blob/main/lib/core/facets/array/before.rb#L35
        #
        def call
          return [] unless array.include?(object)

          Utils::Array.drop_while(array, inclusively: true) { |item| item != object }
        end
      end
    end
  end
end
