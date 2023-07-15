# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        class StubService < Support::Command
          module Entities
            class StubbedService
              include Support::DependencyContainer::Import

              ##
              # @internal
              #   TODO: Implement shorter form in the following way:
              #
              #   import \
              #     command: :SetServiceStubbedResult,
              #     from: ConvenientService::Service::Plugins::CanHaveStubbedResults
              #
              import \
                :"commands.SetServiceStubbedResult",
                from: ConvenientService::Service::Plugins::CanHaveStubbedResults::Container

              ##
              # @param service_class [Class]
              # @return [void]
              #
              def initialize(service_class:)
                @service_class = service_class
                @arguments = Support::Arguments.null_arguments
              end

              ##
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::StubService]
              #
              def with_arguments(...)
                @arguments = Support::Arguments.new(...)

                self
              end

              ##
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::StubService]
              #
              def without_arguments
                @arguments = Support::Arguments.null_arguments

                self
              end

              ##
              # @param result_spec [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::StubService]
              #
              def to(result_spec)
                @result_spec = result_spec

                service_class.commit_config!(trigger: Constants::Triggers::STUB_SERVICE)

                commands.SetServiceStubbedResult[service: service_class, arguments: arguments, result: result_value]

                self
              end

              private

              ##
              # @!attribute [r] service_class
              #   @return [Class]
              #
              attr_reader :service_class

              ##
              # @!attribute [r] arguments
              #   @return [Hash]
              #
              attr_reader :arguments

              ##
              # @!attribute [r] result_spec
              #   @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              #
              attr_reader :result_spec

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result_value
                @result_value ||= result_spec.for(service_class).calculate_value
              end
            end
          end
        end
      end
    end
  end
end
