# frozen_string_literal: true

require_relative "base/commands"

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Entities
              module Printers
                ##
                # @internal
                #   IMPORTANT: Do NOT forget to update the `Null` printer every time when the public interface is changed.
                #
                class Base
                  include Support::Delegate
                  include Support::AbstractMethod

                  ##
                  # @api private
                  #
                  # @!attribute [r] matcher
                  #   @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
                  #
                  attr_reader :matcher

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  abstract_method :got_jsend_attributes_part

                  ##
                  # @api private
                  #
                  # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                  #
                  delegate :result, to: :matcher

                  ##
                  # @api private
                  #
                  # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Chain]
                  #
                  delegate :chain, to: :matcher

                  ##
                  # @api private
                  #
                  # @param matcher [ConvenientService::RSpec::Matchers::Custom::Results::Base]
                  # @return [void]
                  #
                  def initialize(matcher:)
                    @matcher = matcher
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  # @internal
                  #   TODO: Specs.
                  #
                  def description
                    expected_parts
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  # @internal
                  #   TODO: Specs.
                  #
                  def failure_message
                    "expected result to be\n#{default_text}"
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  # @internal
                  #   TODO: Specs.
                  #
                  def failure_message_when_negated
                    "expected result NOT to be\n#{default_text}"
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_parts
                    Commands::GenerateExpectedParts[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def got_parts
                    Commands::GenerateGotParts[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_code_part
                    Commands::GenerateExpectedCodePart[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_data_part
                    Commands::GenerateExpectedDataPart[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_message_part
                    Commands::GenerateExpectedMessagePart[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_service_part
                    Commands::GenerateExpectedServicePart[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_status_part
                    Commands::GenerateExpectedStatusPart[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_step_part
                    Commands::GenerateExpectedStepPart[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def got_step_part
                    Commands::GenerateGotStepPart[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def got_service_part
                    Commands::GenerateGotServicePart[printer: self]
                  end

                  ##
                  # @api private
                  #
                  # @param other [Object] Can be any type.
                  # @return [Boolean, nil]
                  #
                  def ==(other)
                    return unless other.instance_of?(self.class)

                    return false if matcher != other.matcher

                    true
                  end

                  private

                  ##
                  # @return [String]
                  #
                  def default_text
                    expected_parts << "\n\n" << got_parts
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
