# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeNotError < Results::Base
            ##
            # @api private
            #
            # @return [Array<Symbol>]
            #
            def statuses
              [
                Service::Plugins::HasJSendResult::Constants::SUCCESS_STATUS,
                Service::Plugins::HasJSendResult::Constants::FAILURE_STATUS
              ]
            end
          end
        end
      end
    end
  end
end
