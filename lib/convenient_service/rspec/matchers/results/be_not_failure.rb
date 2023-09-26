# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeNotFailure
          ##
          # @api public
          #
          def be_not_failure(...)
            Classes::Results::BeNotFailure.new(...)
          end
        end
      end
    end
  end
end
