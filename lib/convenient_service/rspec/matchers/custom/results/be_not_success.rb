# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeNotSuccess < Results::Base
            def statuses
              [
                Service::Plugins::HasResult::Constants::ERROR_STATUS,
                Service::Plugins::HasResult::Constants::FAILURE_STATUS
              ]
            end
          end
        end
      end
    end
  end
end
