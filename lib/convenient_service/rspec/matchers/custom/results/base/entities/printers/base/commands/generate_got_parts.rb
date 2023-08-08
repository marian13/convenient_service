# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Entities
              module Printers
                class Base
                  module Commands
                    class GenerateGotParts < Support::Command
                      include Support::Delegate

                      ##
                      # @api private
                      #
                      # @!attribute printer [r]
                      #   @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Printers::Base]
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
                      delegate :got_jsend_attributes_part, to: :printer

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      delegate :got_service_part, to: :printer

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      delegate :got_step_part, to: :printer

                      ##
                      # @api private
                      #
                      # @param printer [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Printers::Base]
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
                      # @return [Array<String>]
                      #
                      def parts
                        @parts ||= [
                          "got result",
                          got_jsend_attributes_part,
                          got_service_part,
                          got_step_part
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
