# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class Base
            module Entities
              module Printers
                class Error < Printers::Base
                  module Commands
                    class GenerateGotJsendAttributesPart < Support::Command
                      include Support::Delegate
                      include Support::DependencyContainer::Import

                      ##
                      # @api private
                      #
                      # @!attribute printer [r]
                      #   @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Error]
                      #
                      attr_reader :printer

                      ##
                      # @api private
                      #
                      # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Chain]
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
                      # @return [Symbol]
                      #
                      import :"constants.DEFAULT_ERROR_CODE", from: Service::Plugins::HasJSendResult::Container

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
                      def call
                        return "" unless result

                        return status_part if [chain.used_data?, chain.used_message?, chain.used_code?].none?

                        [status_part, data_part, message_part, code_part].reject(&:empty?).join("\n")
                      end

                      private

                      ##
                      # @return [String]
                      #
                      def status_part
                        "with `error` status"
                      end

                      ##
                      # @return [String]
                      #
                      def data_part
                        data.empty? ? "" : "with data `#{data}`"
                      end

                      ##
                      # @return [String]
                      #
                      def message_part
                        message.empty? ? "with empty message" : "with message `#{message}`"
                      end

                      ##
                      # @return [String]
                      #
                      def code_part
                        (code == constants.DEFAULT_ERROR_CODE) ? "" : "with code `#{code}`"
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

                      ##
                      # @return [Symbol]
                      #
                      def code
                        @code ||= result.unsafe_code.to_sym
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
