# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeNotFailure < Results::Base
            ##
            # @return [Array<Symbol>]
            #
            def statuses
              [
                Service::Plugins::HasJSendResult::Constants::ERROR_STATUS,
                Service::Plugins::HasJSendResult::Constants::SUCCESS_STATUS
              ]
            end
          end
        end
      end
    end
  end
end
