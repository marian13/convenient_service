# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Entities
              module Printers
                class Failure < Printers::Base
                  module Commands
                    class GenerateGotJsendAttributesPart < Support::Command
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
                      def call
                        [status_part, data_part, message_part].reject(&:empty).join("\n")
                      end

                      private

                      ##
                      # @return [String]
                      #
                      def status_part
                        "with `failure` status"
                      end

                      ##
                      # @return [String]
                      #
                      def data_part
                        data.empty? ? "without data" : "with data `#{data}`"
                      end

                      ##
                      # @return [String]
                      #
                      # @internal
                      #   TODO: Duplicated in `HasJSendResult::ClassMethods`.
                      #
                      def message_part
                        return "" if message == data.first.to_s.join(" ")

                        message.empty? ? "with empty message" : "with message `#{message}`"
                      end

                      ##
                      # @return [Hash{Symbol => Object}]
                      #
                      def data
                        @data ||= result.unsafe_data.to_h
                      end

                      ##
                      # @return [String]
                      #
                      def message
                        @message ||= result.unsafe_message.to_s
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
