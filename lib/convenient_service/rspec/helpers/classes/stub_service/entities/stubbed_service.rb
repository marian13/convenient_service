# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class StubService < Support::Command
          module Entities
            class StubbedService
              include Support::DependencyContainer::Import

              ##
              # @param service_class [Class]
              # @return [void]
              #
              # @internal
              #   NOTE: `@arguments = nil` means "match any arguments".
              #
              def initialize(service_class:)
                @service_class = service_class
                @arguments = nil
              end

              ##
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::StubService]
              #
              # @internal
              #   NOTE: `@arguments = nil` means "match any arguments".
              #
              def with_any_arguments(...)
                @arguments = nil

                self
              end

              ##
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::StubService]
              #
              def with_arguments(...)
                @arguments = Support::Arguments.new(...)

                self
              end

              ##
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::StubService]
              #
              def without_arguments
                @arguments = Support::Arguments.null_arguments

                self
              end

              ##
              # @param result_spec [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::StubService]
              #
              def to(result_spec)
                @result_spec = result_spec

                service_class.commit_config!(trigger: Constants::Triggers::STUB_SERVICE)

                Service::Plugins::CanHaveStubbedResults::Commands::SetServiceStubbedResult[service: service_class, arguments: arguments, result: result]

                self
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if service_class != other.service_class
                return false if arguments != other.arguments
                return false if result_spec != other.result_spec

                true
              end

              protected

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
              #   @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              #
              attr_reader :result_spec

              private

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result
                @result ||= result_spec.for(service_class).calculate_value
              end
            end
          end
        end
      end
    end
  end
end
