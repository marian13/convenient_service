# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class Base
            module Entities
              module Printers
                class Base
                  module Commands
                    class GenerateExpectedParts < Support::Command
                      include Support::Delegate

                      ##
                      # @api private
                      #
                      # @!attribute printer [r]
                      #   @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base]
                      #
                      attr_reader :printer

                      ##
                      # @api private
                      #
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      delegate :result, to: :printer

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      delegate :expected_status_part, to: :printer

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      delegate :expected_data_part, to: :printer

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      delegate :expected_message_part, to: :printer

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      delegate :expected_code_part, to: :printer

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      delegate :expected_service_part, to: :printer

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      delegate :expected_step_part, to: :printer

                      ##
                      # @api private
                      #
                      # @param printer [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base]
                      # @return [void]
                      #
                      def initialize(printer:)
                        @printer = printer
                      end

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      # @internal
                      #   TODO: Align for easier visual comparison.
                      #   TODO: New line for each attribute.
                      #
                      def call
                        parts.reject(&:empty?).join("\n")
                      end

                      private

                      ##
                      # @return [String]
                      #
                      def parts
                        [
                          expected_status_part,
                          expected_data_part,
                          expected_message_part,
                          expected_code_part,
                          expected_service_part,
                          expected_step_part
                        ]
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
end
