# frozen_string_literal: true

require_relative "base/constants"
require_relative "base/entities"
require_relative "base/exceptions"

module ConvenientService
  module RSpec
    module Matchers
      module Classes
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
              #
              # TODO: Explainer when `result.class.commit_config!` is required. It was introduced in panic when the first thread-safety issues occurred. Looks like it is an outdated operation now. It is probably useful only when a config has almost zero plugins.
              #
              # TODO: Resolve a bug in `delegate_to`. It makes `respond_to?` always return `true`, even for classes that do NOT have the `commit_config!` method. See specs for details.
              #
              #   let(:result) { "foo" }
              #
              #   specify do
              #     expect { matcher.matches?(result) }
              #       .not_to delegate_to(result.class, :commit_config!)
              #       .with_any_arguments
              #       .without_calling_original
              #   end
              #
              #   `result.class.method(:commit_config!)`
              #   # => <Method: String.commit_config!(*args, &block) /usr/local/bundle/gems/rspec-mocks-3.11.2/lib/rspec/mocks/method_double.rb:63>
              #
              result.class.commit_config!(trigger: Constants::Triggers::BE_RESULT) if result.class.respond_to?(:commit_config!)

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
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def with_data(data)
              chain.data = data

              self
            end

            ##
            # @api public
            #
            # @param data [Hash]
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def and_data(data)
              chain.data = data

              self
            end

            ##
            # @api public
            #
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def without_data
              chain.data = {}

              self
            end

            ##
            # @api public
            #
            # @param message [String]
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def with_message(message)
              chain.message = message

              self
            end

            ##
            # @api public
            #
            # @param message [String]
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def and_message(message)
              chain.message = message

              self
            end

            ##
            # @api public
            #
            # @return [String, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def with_code(code)
              chain.code = code

              self
            end

            ##
            # @api public
            #
            # @return [String, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def and_code(code)
              chain.code = code

              self
            end

            ##
            # @api public
            #
            # @param service [ConvenientService::Service]
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def of_service(service)
              chain.service = service

              self
            end

            ##
            # @api public
            #
            # @param step [Class, Symbol]
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def of_step(step)
              chain.step = step

              self
            end

            ##
            # @api public
            #
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def without_step
              chain.step = nil

              self
            end

            ##
            # @api public
            #
            # @param comparison_method [Symbo, String]
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
            #
            def comparing_by(comparison_method)
              chain.comparison_method = comparison_method

              self
            end

            ##
            # @api private
            #
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Chain]
            #
            def chain
              @chain ||= Entities::Chain.new
            end

            ##
            # @api private
            #
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base]
            #
            def printer
              @printer ||= Entities::Printers.create(matcher: self)
            end

            ##
            # @api private
            #
            # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator]
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
