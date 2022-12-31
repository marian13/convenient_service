# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeSuccess < Results::Base
            def statuses
              [Service::Plugins::HasResult::Constants::SUCCESS_STATUS]
            end
          end
        end
      end
    end
  end
end
