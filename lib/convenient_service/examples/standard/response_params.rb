# frozen_string_literal: true

require_relative "response_params/services"

module ConvenientService
  module Examples
    module Standard
      module ResponseParams
        class << self
          def prepare(response, role: :guest)
            Services::Prepare[response: response, role: role]
          end
        end
      end
    end
  end
end
