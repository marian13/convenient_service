# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Object
      class WithOneTimeObject < Support::Command
        ##
        # @!attribute [r] block
        #   @return [Proc]
        #
        attr_reader :block

        ##
        # @param block [Proc]
        # @return [void]
        #
        def initialize(&block)
          @block = block
        end

        ##
        # @return [Object] Can be any type.
        #
        def call
          block.call(::Object.new)
        end
      end
    end
  end
end
