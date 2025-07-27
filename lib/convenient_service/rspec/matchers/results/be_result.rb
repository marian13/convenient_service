# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "be_result/exceptions"

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeResult
          ##
          # @api public
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
          # @raise [ConvenientService::RSpec::Matchers::Results::BeResult::Exceptions::InvalidStatus]
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
            else
              ::ConvenientService.raise Exceptions::InvalidStatus.new(status: status)
            end
          end
        end
      end
    end
  end
end
