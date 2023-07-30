# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeFailure
          ##
          # @api public
          #
          def be_failure(...)
            Custom::Results::BeFailure.new(...)
          end
        end
      end
    end
  end
end
