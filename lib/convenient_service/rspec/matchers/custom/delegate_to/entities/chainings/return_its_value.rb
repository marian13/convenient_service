# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            module Chainings
              class ReturnItsValue
                include Support::Delegate

                ##
                # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                #
                attr_reader :matcher

                ##
                # @return [Object]
                #
                attr_reader :block_expectation_value

                ##
                # @return [Object]
                #
                delegate :object, to: :matcher

                ##
                # @return [String]
                #
                delegate :method, to: :matcher

                ##
                # @return [Array]
                #
                delegate :expected_arguments, to: :matcher

                ##
                # @return [String]
                #
                delegate :printable_block_expectation, to: :matcher

                ##
                # @return [String]
                #
                delegate :printable_method, to: :matcher

                ##
                # @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                # @return [void]
                #
                def initialize(matcher:)
                  @matcher = matcher
                end

                ##
                # @return [void]
                #
                def apply_mocks!
                end

                ##
                # @param block_expectation_value [Object]
                # @return [Boolean]
                #
                def matches?(block_expectation_value)
                  @block_expectation_value = block_expectation_value

                  ##
                  # IMPORTANT: `and_return_its_value` works only when `delegate_to` checks a pure function.
                  #
                  # For example (1):
                  #   def require_dependencies_pure
                  #     RequireDependenciesPure.call
                  #   end
                  #
                  #   class RequireDependenciesPure
                  #     def self.call
                  #       dependencies.require!
                  #
                  #       true
                  #     end
                  #   end
                  #
                  #   # Works since `RequireDependenciesPure.call` always returns `true`.
                  #   specify do
                  #     expect { require_dependencies_pure }
                  #       .to delegate_to(RequireDependenciesPure, :call)
                  #       .and_return_its_value
                  #   end
                  #
                  # Example (2):
                  #   def require_dependencies_not_pure
                  #     RequireDependenciesNotPure.call
                  #   end
                  #
                  #   class RequireDependenciesNotPure
                  #     def self.call
                  #       return false if dependencies.required?
                  #
                  #       dependencies.require!
                  #
                  #       true
                  #     end
                  #   end
                  #
                  #   # Does NOT work since `RequireDependenciesNotPure.call` returns `true` for the first time and `false` for the subsequent call.
                  #   specify do
                  #     expect { require_dependencies_not_pure }
                  #       .to delegate_to(RequireDependenciesNotPure, :call)
                  #       .and_return_its_value
                  #   end
                  #
                  # NOTE: If this expectation fails, it means `and_return_its_value` is NOT met.
                  #
                  block_expectation_value == delegation_value
                end

                ##
                # @param value [Object]
                # @return [Boolean]
                #
                def does_not_match?(value)
                  !matches?(value)
                end

                ##
                # @return [String]
                #
                def failure_message
                  <<~MESSAGE
                    expected `#{printable_block_expectation}` to delegate to `#{printable_method}` and return its value, but it didn't.

                    `#{printable_block_expectation}` returns `#{value}`, but delegation returns `#{delegation_value}`.
                  MESSAGE
                end

                private

                def delegation_value
                  object.__send__(method, *expected_arguments.args, **expected_arguments.kwargs, &expected_arguments.block)
                end
              end
            end
          end
        end
      end
    end
  end
end
