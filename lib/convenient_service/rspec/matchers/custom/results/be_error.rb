# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeError < Results::Base
            def statuses
              [Service::Plugins::HasResult::Constants::ERROR_STATUS]
            end
          end
        end
      end
    end
  end
end
