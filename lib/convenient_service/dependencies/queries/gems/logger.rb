# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Dependencies
    module Queries
      module Gems
        class Logger
          class << self
            ##
            # @api private
            #
            # @return [Boolean]
            #
            # @internal
            #   `Style/TernaryParentheses` is disabled since `defined?` has too low priority without parentheses.
            #
            # rubocop:disable Style/TernaryParentheses
            def loaded?
              (defined? ::Logger) ? true : false
            end
            # rubocop:enable Style/TernaryParentheses

            ##
            # @api private
            #
            # @return [ConvenientService::Dependencies::Queries::Version]
            #
            # @internal
            #   - https://github.com/ruby/logger/blob/v1.5.3/lib/logger/version.rb
            #
            def version
              loaded? ? Version.new(::Logger::VERSION) : Version.null_version
            end
          end
        end
      end
    end
  end
end
