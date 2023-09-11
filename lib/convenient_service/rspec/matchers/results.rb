# frozen_string_literal: true

require_relative "results/be_error"
require_relative "results/be_failure"
require_relative "results/be_success"

require_relative "results/be_not_error"
require_relative "results/be_not_failure"
require_relative "results/be_not_success"

require_relative "results/be_result"

module ConvenientService
  module RSpec
    module Matchers
      module Results
        include Support::Concern

        included do
          include Results::BeError
          include Results::BeFailure
          include Results::BeSuccess

          include Results::BeNotError
          include Results::BeNotFailure
          include Results::BeNotSuccess

          include Results::BeResult
        end
      end
    end
  end
end
