# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Dependencies
    module Queries
      module Gems
        ##
        # @api private
        #
        class Minitest
          class << self
            ##
            # @return [Boolean]
            #
            # @internal
            #   `Style/TernaryParentheses` is disabled since `defined?` has too low priority without parentheses.
            #
            # rubocop:disable Style/TernaryParentheses
            def loaded?
              (defined? ::Minitest) ? true : false
            end
            # rubocop:enable Style/TernaryParentheses

            ##
            # @return [ConvenientService::Dependencies::Queries::Version]
            #
            # @internal
            #   - https://github.com/minitest/minitest/blob/master/lib/minitest.rb
            #
            def version
              loaded? ? Version.new(::Minitest::VERSION) : Version.null_version
            end

            ##
            # @internal
            #   Minitest does NOT have `::RSpec.current_example` equivalent.
            #   -
            #
            # def current_example
            #   return unless loaded?
            #
            #   # ...
            # end
            ##
          end
        end
      end
    end
  end
end
