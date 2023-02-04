# frozen_string_literal: true

require_relative "factories/services"
require_relative "factories/results"
require_relative "factories/steps"

module ConvenientService
  module Factories
    extend Services
    extend Results
    extend Steps
  end
end
