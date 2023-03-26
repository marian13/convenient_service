# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        class StubService < Support::Command
          module Entities
            class StubbedService
              ##
              # @param service_class [Class]
              # @return [void]
              #
              def initialize(service_class:)
                @service_class = service_class
                @arguments = {args: [], kwargs: {}, block: nil}
              end

              ##
              # @param args [Array<Object>]
              # @param kwargs [Hash{Symbol => Object}]
              # @param block [Block]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::StubService]
              #
              def with_arguments(*args, **kwargs, &block)
                @arguments = {args: args, kwargs: kwargs, block: block}

                self
              end

              ##
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::StubService]
              #
              def without_arguments
                @arguments = {args: [], kwargs: {}, block: nil}

                self
              end

              ##
              # @param result_spec [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::StubService]
              #
              def to(result_spec)
                @result_spec = result_spec

                service_class.commit_config!(trigger: Constants::Triggers::STUB_SERVICE)

                service_class.stubbed_results[key] = result_value

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
              # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
              #
              def result_value
                @result_value ||= result_spec.for(service_class).calculate_value
              end

              ##
              # @return [ConvenientService::Support::Cache::Key]
              #
              def key
                @key ||= service_class.stubbed_results.keygen(*arguments[:args], **arguments[:kwargs], &arguments[:block])
              end
            end
          end
        end
      end
    end
  end
end
