# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module String
      ##
      # @example Common usage.
      #   ConvenientService::Utils::String::Tab.call("foo\nbar\nbaz")
      #   # => "  foo\n  bar\n  baz"
      #
      #   ConvenientService::Utils::String::Tab.call("foo\nbar\nbaz", tab_size: 4)
      #   # => "    foo\n    bar\n    baz"
      #
      class Tab < Support::Command
        ##
        # @!attribute [r] string
        #   @return [String]
        #
        attr_reader :string

        ##
        # @!attribute [r] tab_size
        #   @return [Integer]
        #
        attr_reader :tab_size

        ##
        # @param string [String]
        # @param tab_size [Integer]
        # @return [void]
        #
        def initialize(string, tab_size: 2)
          @string = string.to_s
          @tab_size = tab_size
        end

        ##
        # @return [String]
        #
        def call
          string.lines.map { |line| "#{tab}#{line}" }.join
        end

        private

        ##
        # @return [String]
        #
        def tab
          @tab ||= " " * tab_size
        end
      end
    end
  end
end
