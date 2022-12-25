# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                module Chainings
                  class Base
                    ##
                    # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                    #
                    attr_reader :matcher

                    ##
                    # @return [Object] Can be any type.
                    #
                    attr_reader :block_expectation_value

                    ##
                    # @overload initialize(matcher:)
                    #   @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                    #   @return [void]
                    #
                    # @overload initialize(matcher:, block_expectation_value:)
                    #   @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                    #   @param block_expectation_value [Object] Can be any type.
                    #   @return [void]
                    #   @api private
                    #
                    def initialize(matcher:, block_expectation_value: nil)
                      @matcher = matcher
                      @block_expectation_value = block_expectation_value
                    end

                    ##
                    # @return [void]
                    #
                    def apply_stubs!
                    end

                    ##
                    # @param block_expectation_value [Object] Can be any type.
                    # @return [Boolean]
                    #
                    def matches?(block_expectation_value)
                      @block_expectation_value = block_expectation_value

                      false
                    end

                    ##
                    # @param block_expectation_value [Object] Can be any type.
                    # @return [Boolean]
                    #
                    def does_not_match?(block_expectation_value)
                      return true unless matches?(block_expectation_value)

                      false
                    end

                    ##
                    # @return [Boolean]
                    #
                    def should_call_original?
                      false
                    end

                    ##
                    # @return [String]
                    #
                    def failure_message
                      ""
                    end

                    ##
                    # @return [String]
                    #
                    def failure_message_when_negated
                      ""
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
