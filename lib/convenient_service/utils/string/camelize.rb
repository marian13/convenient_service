# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module String
      ##
      # Converts strings to UpperCamelCase (`capitalize_first_letter` option is set to `true` by default).
      # Implementation is very basic just to serve the need of this library.
      # More comprehensive solution can be found in Rails, for example:
      # - https://github.com/rails/rails/blob/5aaaa1630ae9a71b3c3ecc4dc46074d678c08d67/activesupport/lib/active_support/core_ext/string/inflections.rb#L103
      # - https://github.com/rails/rails/blob/5aaaa1630ae9a71b3c3ecc4dc46074d678c08d67/activesupport/lib/active_support/inflector/methods.rb#L53
      #
      class Camelize < Support::Command
        ##
        # @!attribute [r] string
        #   @return [String]
        #
        attr_reader :string

        ##
        # @!attribute [r] capitalize_first_letter
        #   @return [Boolean]
        #
        attr_reader :capitalize_first_letter

        ##
        # @param string [#to_s]
        # @return [void]
        #
        def initialize(string, capitalize_first_letter: true)
          @string = string.to_s
          @capitalize_first_letter = capitalize_first_letter
        end

        ##
        # @return [String]
        #
        def call
          camelized = string.split(/[:_?!\-\ ]/).map { |part| upcase_first_char(part) }.join

          camelized[0] = camelized[0].downcase unless capitalize_first_letter

          camelized
        end

        private

        ##
        # @param part [String]
        # @return [String]
        #
        def upcase_first_char(part)
          return part if part.empty?

          "#{part[0].upcase}#{part[1..]}"
        end
      end
    end
  end
end
