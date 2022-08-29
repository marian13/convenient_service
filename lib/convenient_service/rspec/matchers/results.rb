# frozen_string_literal: true

require_relative "results/be_error"
require_relative "results/be_failure"
require_relative "results/be_success"

module ConvenientService
  module RSpec
    module Matchers
      module Results
        include Support::Concern

        included do
          include Results::BeError
          include Results::BeFailure
          include Results::BeSuccess
        end
      end
    end
  end
end
