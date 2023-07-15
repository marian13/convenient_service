# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class MatchResultCode < Support::Command
                ##
                # @!attribute [r] result
                #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @!attribute [r] code
                #   @return [Symbol]
                #
                attr_reader :code

                ##
                # @!attribute [r] comparison_method
                #   @return [Symbol, String]
                #
                attr_reader :comparison_method

                ##
                # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                # @param code [Symbol]
                # @param comparison_method [String, Symbol]
                # @return [void]
                #
                def initialize(result:, code:, comparison_method: Constants::DEFAULT_COMPARISON_METHOD)
                  @result = result
                  @code = code
                  @comparison_method = comparison_method
                end

                ##
                # @return [Boolean]
                #
                def call
                  casted_code.public_send(comparison_method, result.unsafe_code)
                end

                private

                ##
                # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                #
                def casted_code
                  result.class.code(value: code, result: result)
                end
              end
            end
          end
        end
      end
    end
  end
end
