# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeNotError
          def be_not_error(...)
            Custom::Results::BeNotError.new(...)
          end
        end
      end
    end
  end
end
