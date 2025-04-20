# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module String
      class Split < Support::Command
        ##
        # @!attribute [r] string
        #   @return [String]
        #
        attr_reader :string

        ##
        # @!attribute [r] delimiters
        #   @return [Array<String>]
        #
        attr_reader :delimiters

        ##
        # @param string [#to_s]
        # @param delimiters [Array<String>]
        # @return [void]
        #
        def initialize(string, *delimiters)
          @string = string.to_s
          @delimiters = delimiters
        end

        ##
        # @return [String]
        #
        # @internal
        #   https://stackoverflow.com/a/51380514/12201472
        #
        def call
          string.split(::Regexp.union(delimiters))
        end
      end
    end
  end
end
