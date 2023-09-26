# frozen_string_literal: true

require_relative "stub_service/constants"
require_relative "stub_service/entities"

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        ##
        # TODO: Specs.
        #
        class StubService < Support::Command
          attr_reader :service_class

          def initialize(service_class)
            @service_class = service_class
          end

          def call
            Entities::StubbedService.new(service_class: @service_class)
          end
        end
      end
    end
  end
end
