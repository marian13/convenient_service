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
      #   ConvenientService::Utils::String::Enclose.call("foo", "_")
      #   # => "_foo_"
      #
      #   ConvenientService::Utils::String::Enclose.call("", "_")
      #   # => "_"
      #
      #   ConvenientService::Utils::String::Enclose.call(nil, "_")
      #   # => "_"
      #
      class Enclose < Support::Command
        ##
        # @!attribute [r] string
        #   @return [String]
        #
        attr_reader :string

        ##
        # @!attribute [r] char
        #   @return [String]
        #
        attr_reader :char

        ##
        # @param string [String]
        # @param char [String]
        # @return [void]
        #
        def initialize(string, char)
          @string = string
          @char = char
        end

        ##
        # @return [String]
        #
        def call
          return char unless string
          return char if string.empty?

          "#{char}#{string}#{char}"
        end
      end
    end
  end
end
