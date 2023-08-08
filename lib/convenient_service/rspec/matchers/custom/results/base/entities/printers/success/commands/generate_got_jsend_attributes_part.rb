# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Entities
              module Printers
                class Success < Printers::Base
                  module Commands
                    class GenerateGotJsendAttributesPart < Support::Command
                      include Support::Delegate

                      ##
                      # @api private
                      #
                      # @!attribute printer [r]
                      #   @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Printers::Success]
                      #
                      attr_reader :printer

                      ##
                      # @api private
                      #
                      # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Chain]
                      #
                      delegate :chain, to: :printer

                      ##
                      # @api private
                      #
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      delegate :result, to: :printer

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
                      #   TODO: Specs for `...].none?`.
                      #
                      def call
                        return "" unless result

                        return status_part if [chain.used_data?, chain.used_message?, chain.used_code?].none?

                        [status_part, data_part].join("\n")
                      end

                      private

                      ##
                      # @return [String]
                      #
                      def status_part
                        "with `success` status"
                      end

                      ##
                      # @return [String]
                      #
                      def data_part
                        data.empty? ? "with empty data" : "with data `#{data}`"
                      end

                      ##
                      # @return [Hash{Symbol => Object}]
                      #
                      def data
                        @data ||= result.unsafe_data.to_h
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
