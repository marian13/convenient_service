# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeError
          ##
          # @api public
          #
          def be_error(...)
            Custom::Results::BeError.new(...)
          end
        end
      end
    end
  end
end
