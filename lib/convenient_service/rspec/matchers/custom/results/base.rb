# frozen_string_literal: true

require_relative "base/commands"
require_relative "base/constants"
require_relative "base/errors"

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            include Support::AbstractMethod

            ##
            # @return [String, Symbol]
            #
            abstract_method :statuses

            ##
            # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            # @return [Boolean]
            #
            def matches?(result)
              @result = result

              Commands::MatchResult.call(matcher: self, result: result)
            end

            ##
            # @return [String]
            #
            def description
              expected_parts
            end

            ##
            # @return [String]
            #
            def failure_message
              "expected that `#{result.service.class}` result would #{default_text}"
            end

            ##
            # @return [String]
            #
            # @internal
            #   https://relishapp.com/rspec/rspec-expectations/v/3-11/docs/custom-matchers/define-a-custom-matcher#overriding-the-failure-message-when-negated
            #
            def failure_message_when_negated
              "expected that `#{result.service.class}` result would NOT #{default_text}"
            end

            ##
            # @param data [Hash]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def with_data(data)
              chain[:data] = data

              self
            end

            ##
            # @param data [Hash]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def and_data(data)
              chain[:data] = data

              self
            end

            ##
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def without_data
              chain[:data] = {}

              self
            end

            ##
            # @param message [String]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def with_message(message)
              chain[:message] = message

              self
            end

            ##
            # @param message [String]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def and_message(message)
              chain[:message] = message

              self
            end

            ##
            # @return [String, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def with_code(code)
              chain[:code] = code

              self
            end

            ##
            # @return [String, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def and_code(code)
              chain[:code] = code

              self
            end

            ##
            # @param service_class [Class]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def of_service(service_class)
              chain[:service_class] = service_class

              self
            end

            ##
            # @param step [Class, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def of_step(step)
              chain[:step] = step

              self
            end

            ##
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def without_step
              chain[:step] = nil

              self
            end

            ##
            # @param comparison_method [Symbol]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def comparing_by(comparison_method)
              chain[:comparison_method] = comparison_method

              self
            end

            ##
            # @!attribute [r] result
            #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            attr_reader :result

            ##
            # @return [String]
            #
            def default_text
              expected_parts << "\n\n" << got_parts
            end

            ##
            # @return [String]
            #
            # @internal
            #   TODO: Align for easier visual comparison.
            #   TODO: New line for each attribute.
            #
            def expected_parts
              parts = []

              parts << "be #{printable_statuses}"
              parts << "of service `#{service_class}`" if used_of_service?
              parts << Commands::GenerateExpectedStepPart.call(step: step) if used_of_step?
              parts << "with data `#{data}`" if used_data?
              parts << "with message `#{message}`" if used_message?
              parts << "with code `#{code}`" if used_code?

              parts.join(" ")
            end

            ##
            # @return [String]
            #
            # @internal
            #   TODO: Align for easier visual comparison.
            #   TODO: New line for each attribute.
            #
            def got_parts
              parts = []

              parts << "got `#{result.status}`"
              parts << "of service `#{result.service.class}`" if used_of_service?
              parts << Commands::GenerateGotStepPart.call(result: result) if used_of_step?
              parts << "with data `#{result.unsafe_data}`" if used_data?
              parts << "with message `#{result.unsafe_message}`" if used_message?
              parts << "with code `#{result.unsafe_code}`" if used_code?

              parts.join(" ")
            end

            ##
            # @return [Boolean]
            #
            def used_data?
              chain.key?(:data)
            end

            ##
            # @return [Boolean]
            #
            def used_message?
              chain.key?(:message)
            end

            ##
            # @return [Boolean]
            #
            def used_code?
              chain.key?(:code)
            end

            ##
            # @return [Boolean]
            #
            def used_of_service?
              chain.key?(:service_class)
            end

            ##
            # @return [Boolean]
            #
            def used_of_step?
              chain.key?(:step)
            end

            ##
            # @return [Hash]
            #
            def data
              @data ||= chain[:data] || {}
            end

            ##
            # @return [String]
            #
            def message
              @message ||= chain[:message] || ""
            end

            ##
            # @return [String, Symbol]
            #
            def code
              @code ||= chain[:code] || ""
            end

            ##
            # @return [Symbol]
            #
            def comparison_method
              @comparison_method ||= chain[:comparison_method] || Constants::DEFAULT_COMPARISON_METHOD
            end

            ##
            # @return [Class]
            #
            def service_class
              Utils::Object.memoize_including_falsy_values(self, :@service_class) { chain[:service_class] }
            end

            ##
            # @return [Class]
            #
            def step
              Utils::Object.memoize_including_falsy_values(self, :@step) { chain[:step] }
            end

            private

            ##
            # @return [Hash]
            #
            def chain
              @chain ||= {}
            end

            ##
            # @return [String]
            #
            def printable_statuses
              statuses.map { |status| "`#{status}`" }.join(" or ")
            end
          end
        end
      end
    end
  end
end
