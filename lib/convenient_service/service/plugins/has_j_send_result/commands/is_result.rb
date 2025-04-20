# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Commands
          class IsResult < Support::Command
            ##
            # @!attribute [r] result
            #   @return [Object] Can be any type.
            #
            attr_reader :result

            ##
            # @param result [Object] Can be any type.
            # @return [void]
            #
            def initialize(result:)
              @result = result
            end

            ##
            # @return [void]
            #
            def call
              result.class.include?(Entities::Result::Concern)
            end
          end
        end
      end
    end
  end
end
