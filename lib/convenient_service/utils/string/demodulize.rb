# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module String
      ##
      # @example
      #   demodulize('ActiveSupport::Inflector::Inflections') # => "Inflections"
      #   demodulize('Inflections')                           # => "Inflections"
      #   demodulize('::Inflections')                         # => "Inflections"
      #   demodulize('')                                      # => ""
      #
      # @see https://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-demodulize
      #
      class Demodulize < Support::Command
        ##
        # @!attribute [r] string
        #   @return [String]
        #
        attr_reader :string

        ##
        # @param string [#to_s]
        # @return [void]
        #
        def initialize(string)
          @string = string.to_s
        end

        ##
        # @return [String]
        #
        # @internal
        #   NOTE: Copied with cosmetic modifications from:
        #   - https://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-demodulize
        #
        #   NOTE: Modifications.
        #   - `string` is `path.to_s` is the original implementation.
        #   - Fixed Rubocop complaint about `Style/SlicingWithRange`.
        #   - Fixed Rubocop complaint about `Lint/AssignmentInCondition`.
        #
        def call
          i = string.rindex("::")

          i ? string[(i + 2)..] : string
        end
      end
    end
  end
end
