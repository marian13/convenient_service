# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class BeNotSuccess < Results::Base
            ##
            # @api private
            #
            # @return [Array<Symbol>]
            #
            def statuses
              [
                Service::Plugins::HasJSendResult::Constants::FAILURE_STATUS,
                Service::Plugins::HasJSendResult::Constants::ERROR_STATUS
              ]
            end
          end
        end
      end
    end
  end
end
