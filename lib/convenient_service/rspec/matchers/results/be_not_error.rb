# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeNotError
          ##
          # @api public
          #
          def be_not_error(...)
            Classes::Results::BeNotError.new(...)
          end
        end
      end
    end
  end
end
