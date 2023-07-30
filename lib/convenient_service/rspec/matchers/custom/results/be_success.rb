# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeSuccess < Results::Base
            ##
            # @api private
            #
            # @return [Array<Symbol>]
            #
            def statuses
              [Service::Plugins::HasJSendResult::Constants::SUCCESS_STATUS]
            end
          end
        end
      end
    end
  end
end
