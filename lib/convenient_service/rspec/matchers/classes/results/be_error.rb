# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class BeError < Results::Base
            ##
            # @api private
            #
            # @return [Array<Symbol>]
            #
            def statuses
              [Service::Plugins::HasJSendResult::Constants::ERROR_STATUS]
            end
          end
        end
      end
    end
  end
end
