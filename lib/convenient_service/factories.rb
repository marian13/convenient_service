# frozen_string_literal: true

require_relative "factories/arguments"
require_relative "factories/services"
require_relative "factories/results"
require_relative "factories/steps"

require_relative "factories/step"

##
# WIP: Factory API is NOT well-thought yet. It will be revisited and completely refactored at any time.
#
module ConvenientService
  module Factories
    extend Arguments
    extend Services
    extend Results
    extend Steps

    extend Step::Instance
  end
end
