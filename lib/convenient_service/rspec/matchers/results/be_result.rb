# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeResult
          ##
          # @api public
          #
          def be_result(status, *args, **kwargs, &block)
            case status
            when :success
              Classes::Results::BeSuccess.new(*args, **kwargs, &block)
            when :failure
              Classes::Results::BeFailure.new(*args, **kwargs, &block)
            when :error
              Classes::Results::BeError.new(*args, **kwargs, &block)
            when :not_success
              Classes::Results::BeNotSuccess.new(*args, **kwargs, &block)
            when :not_failure
              Classes::Results::BeNotFailure.new(*args, **kwargs, &block)
            when :not_error
              Classes::Results::BeNotError.new(*args, **kwargs, &block)
            end
          end
        end
      end
    end
  end
end
