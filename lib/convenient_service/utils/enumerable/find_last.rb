# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Enumerable
      class FindLast < Support::Command
        ##
        # @!attribute [r] enumerable
        #   @return [Enumerable]
        #
        attr_reader :enumerable

        ##
        # @!attribute [r] block
        #   @return [Proc]
        #
        attr_reader :block

        ##
        # @param enumerable [Enumerable]
        # @param block [Proc, nil]
        # @return [void]
        #
        def initialize(enumerable, &block)
          @enumerable = enumerable
          @block = block
        end

        ##
        # @return [Object] Can be any type.
        #
        # @note Works with custom `Enumerable` objects.
        # @see https://ruby-doc.org/core-2.7.0/Enumerable.html
        #
        def call
          enumerable.reverse_each { |item| return item if block.call(item) }

          nil
        end
      end
    end
  end
end
