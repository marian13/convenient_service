# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeFailure < Results::Base
            ##
            # @return [Array<Symbol>]
            #
            def statuses
              [Service::Plugins::HasResult::Constants::FAILURE_STATUS]
            end
          end
        end
      end
    end
  end
end
