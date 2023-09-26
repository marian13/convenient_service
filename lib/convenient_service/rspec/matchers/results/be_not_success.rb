# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeNotSuccess
          ##
          # @api public
          #
          def be_not_success(...)
            Classes::Results::BeNotSuccess.new(...)
          end
        end
      end
    end
  end
end
