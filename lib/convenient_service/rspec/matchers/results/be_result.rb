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
              Custom::Results::BeSuccess.new(*args, **kwargs, &block)
            when :failure
              Custom::Results::BeFailure.new(*args, **kwargs, &block)
            when :error
              Custom::Results::BeError.new(*args, **kwargs, &block)
            when :not_success
              Custom::Results::BeNotSuccess.new(*args, **kwargs, &block)
            when :not_failure
              Custom::Results::BeNotFailure.new(*args, **kwargs, &block)
            when :not_error
              Custom::Results::BeNotError.new(*args, **kwargs, &block)
            end
          end
        end
      end
    end
  end
end
