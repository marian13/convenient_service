# frozen_string_literal: true

require_relative "base/constants"
require_relative "base/entities"
require_relative "base/errors"

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            include Support::AbstractMethod

            ##
            # @api private
            #
            # @!attribute [r] result
            #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            attr_reader :result

            ##
            # @api private
            #
            # @return [String, Symbol]
            #
            abstract_method :statuses

            ##
            # @api private
            #
            # @return [void]
            #
            def initialize(statuses: self.statuses, result: nil)
              chain.statuses = statuses

              @result = result
            end

            ##
            # @api public
            #
            # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            # @return [Boolean]
            #
            def matches?(result)
              @result = result

              ##
              # IMPORTANT: Makes `result.class.include?` idempotent.
              # TODO: Explainer when `result.commit_config!` is required.
              #
              result.commit_config!(trigger: Constants::Triggers::BE_RESULT) if result.respond_to?(:commit_config!)

              validator.valid_result?
            end

            ##
            # @api public
            #
            # @return [String]
            #
            def description
              printer.description
            end

            ##
            # @api public
            #
            # @return [String]
            #
            def failure_message
              printer.failure_message
            end

            ##
            # @api public
            #
            # @return [String]
            #
            # @internal
            #   - https://relishapp.com/rspec/rspec-expectations/v/3-11/docs/custom-matchers/define-a-custom-matcher#overriding-the-failure-message-when-negated
            #
            def failure_message_when_negated
              printer.failure_message_when_negated
            end

            ##
            # @api public
            #
            # @param data [Hash]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def with_data(data)
              chain.data = data

              self
            end

            ##
            # @api public
            #
            # @param data [Hash]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def and_data(data)
              chain.data = data

              self
            end

            ##
            # @api public
            #
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def without_data
              chain.data = {}

              self
            end

            ##
            # @api public
            #
            # @param message [String]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def with_message(message)
              chain.message = message

              self
            end

            ##
            # @api public
            #
            # @param message [String]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def and_message(message)
              chain.message = message

              self
            end

            ##
            # @api public
            #
            # @return [String, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def with_code(code)
              chain.code = code

              self
            end

            ##
            # @api public
            #
            # @return [String, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def and_code(code)
              chain.code = code

              self
            end

            ##
            # @api public
            #
            # @param service [ConvenientService::Service]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def of_service(service)
              chain.service = service

              self
            end

            ##
            # @api public
            #
            # @param step [Class, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def of_step(step)
              chain.step = step

              self
            end

            ##
            # @api public
            #
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def without_step
              chain.step = nil

              self
            end

            ##
            # @api public
            #
            # @param comparison_method [Symbo, String]
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
            #
            def comparing_by(comparison_method)
              chain.comparison_method = comparison_method

              self
            end

            ##
            # @api private
            #
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Chain]
            #
            def chain
              @chain ||= Entities::Chain.new
            end

            ##
            # @api private
            #
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Printers::Base]
            #
            def printer
              @printer ||= Entities::Printers.create(matcher: self)
            end

            ##
            # @api private
            #
            # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Validator]
            #
            def validator
              @validator ||= Entities::Validator.new(matcher: self)
            end

            ##
            # @api private
            #
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if chain != other.chain
              return false if result != other.result

              true
            end
          end
        end
      end
    end
  end
end
