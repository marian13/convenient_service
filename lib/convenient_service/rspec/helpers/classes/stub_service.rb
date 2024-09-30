# frozen_string_literal: true

require_relative "stub_service/constants"
require_relative "stub_service/entities"

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        ##
        # TODO: Direct Specs.
        #
        class StubService < Support::Command
          ##
          # @!attribute [r] service_class
          #   @return [ConvenientService::Service]
          #
          attr_reader :service_class

          ##
          # @param service_class [ConvenientService::Service]
          # @return [void]
          #
          def initialize(service_class)
            @service_class = service_class
          end

          ##
          # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::StubbedService]
          #
          def call
            Entities::StubbedService.new(service_class: service_class)
          end
        end
      end
    end
  end
end
