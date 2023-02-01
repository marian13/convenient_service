# frozen_string_literal: true

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
            # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
            # @return [Boolean]
            #
            def matches?(result)
              @result = result

              rules = []

              rules << ->(result) { result.class.include?(Service::Plugins::HasResult::Entities::Result::Concern) }
              rules << ->(result) { result.status.in?(statuses) }
              rules << ->(result) { result.service.instance_of?(service_class) } if used_of_service?
              rules << ->(result) { result.step.service.klass == step_class } if used_of_step?
              rules << ->(result) { result.unsafe_data == data } if used_data?
              rules << ->(result) { result.unsafe_message == message } if used_message?
              rules << ->(result) { result.unsafe_code == code } if used_code?

              condition = Utils::Proc.conjunct(rules)

              condition.call(result)
            end

            ##
            # @return [String]
            #
            def description
              default_text
            end

            ##
            # @return [String]
            #
            def failure_message
              "expected that `#{result.class}` would #{default_text}"
            end

            ##
            # @return [String]
            #
            # @internal
            #   https://relishapp.com/rspec/rspec-expectations/v/3-11/docs/custom-matchers/define-a-custom-matcher#overriding-the-failure-message-when-negated
            #
            def failure_message_when_negated
              "expected that #{result.class} would NOT #{default_text}"
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
            # @param step_class [Class, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def of_step(step_class)
              chain[:step_class] = step_class

              self
            end

            private

            ##
            # @!attribute [r] result
            #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
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
            def expected_parts
              parts = []

              parts << "be #{printable_statuses}"
              parts << "of service `#{service_class}`" if used_of_service?
              parts << "of step `#{step_class}`" if used_of_step?
              parts << "with data `#{data}`" if used_data?
              parts << "with message `#{message}`" if used_message?
              parts << "with code `#{code}`" if used_code?

              parts.join(" ")
            end

            ##
            # @return [String]
            #
            def got_parts
              parts = []

              parts << "got `#{result.status}`"
              parts << "of service `#{result.service.class}`" if used_of_service?
              parts << "of step `#{result.step.service.klass}`" if used_of_step?
              parts << "with data `#{result.data}`" if used_data?
              parts << "with message `#{result.message}`" if used_message?
              parts << "with code `#{result.code}`" if used_code?

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
              chain.key?(:step_class)
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
            # @return [Class]
            #
            def service_class
              Utils::Object.instance_variable_fetch(self, :@service_class) { chain[:service_class] }
            end

            ##
            # @return [Class]
            #
            def step_class
              Utils::Object.instance_variable_fetch(self, :@step_class) { chain[:step_class] }
            end

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
