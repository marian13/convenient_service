# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class MatchResultMessage < Support::Command
                ##
                # @!attribute [r] result
                #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @!attribute [r] message
                #   @return [String]
                #
                attr_reader :message

                ##
                # @!attribute [r] comparison_method
                #   @return [Symbol, String]
                #
                attr_reader :comparison_method

                ##
                # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @param message [String]
                # @param comparison_method [String, Symbol]
                # @return [void]
                #
                def initialize(result:, message:, comparison_method: Constants::DEFAULT_COMPARISON_METHOD)
                  @result = result
                  @message = message
                  @comparison_method = comparison_method
                end

                ##
                # @return [Boolean]
                #
                def call
                  casted_message.public_send(comparison_method, result.unsafe_message)
                end

                private

                ##
                # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                #
                def casted_message
                  result.class.message(value: message, result: result)
                end
              end
            end
          end
        end
      end
    end
  end
end
