# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Config
    module Commands
      class NormalizeOptions < Support::Command
        ##
        # @!attribute [r] options
        #   @return [Array<Object>]
        #
        attr_reader :options

        ##
        # @param options [Array<Object>]
        # @return [void]
        #
        def initialize(options:)
          @options = options
        end

        ##
        # @return [Set]
        #
        def call
          ::Set[*normalized_options]
        end

        ##
        # @return [Array<Symbol>]
        #
        def normalized_options
          @normalized_options ||=
            options.to_a.flat_map do |option|
              case option
              when ::Set
                option.to_a
              when ::Hash
                option.select { |_, condition| condition }.keys
              else
                option
              end
            end
        end
      end
    end
  end
end
