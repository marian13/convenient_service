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
        class ActiveModel
          class << self
            ##
            # @return [Boolean]
            #
            # @internal
            #   `Style/TernaryParentheses` is disabled since `defined?` has too low priority without parentheses.
            #
            # rubocop:disable Style/TernaryParentheses
            def loaded?
              (defined? ::ActiveModel) ? true : false
            end
            # rubocop:enable Style/TernaryParentheses

            ##
            # @return [ConvenientService::Dependencies::Queries::Version]
            #
            # @internal
            #   https://github.com/rails/rails/blob/main/activemodel/lib/active_model/version.rb
            #
            def version
              loaded? ? Version.new(::ActiveModel.version) : Version.null_version
            end
          end
        end
      end
    end
  end
end
