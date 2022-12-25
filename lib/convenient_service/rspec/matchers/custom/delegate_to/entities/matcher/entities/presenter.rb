# frozen_string_literal: true

require_relative "presenter/commands"

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                class Presenter
                  ##
                  # @!attribute [r] matcher
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher]
                  #
                  attr_reader :matcher

                  ##
                  # @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher]
                  # @return [void]
                  #
                  def initialize(matcher:)
                    @matcher = matcher
                  end

                  ##
                  # @return [String]
                  #
                  def printable_method
                    @printable_method ||= Commands::GeneratePrintableMethod.call(object: matcher.object, method: matcher.method)
                  end

                  ##
                  # @return [String]
                  #
                  def printable_block_expectation
                    @printable_block_expectation ||= Utils::Proc.display(matcher.block_expectation)
                  end

                  ##
                  # @return [String]
                  #
                  def printable_actual_arguments
                    matcher.delegations
                      .map { |delegation| Commands::GeneratePrintableArguments.call(arguments: delegation.arguments) }
                      .join(", ")
                  end

                  ##
                  # @return [String]
                  #
                  def printable_expected_arguments
                    return "" if matcher.expected_arguments.null_arguments?

                    Commands::GeneratePrintableArguments.call(arguments: matcher.expected_arguments)
                  end

                  ##
                  # @param other [Object] Can be any type.
                  # @return [Boolean]
                  #
                  def ==(other)
                    return unless other.instance_of?(self.class)

                    return false if matcher != other.matcher

                    true
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
