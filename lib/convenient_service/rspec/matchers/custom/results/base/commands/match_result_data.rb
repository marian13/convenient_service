# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class MatchResultData < Support::Command
                ##
                # @!attribute [r] result
                #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @!attribute [r] data
                #   @return [Hash{Symbol => Object}]
                #
                attr_reader :data

                ##
                # @!attribute [r] comparison_method
                #   @return [Symbol, String]
                #
                attr_reader :comparison_method

                ##
                # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                # @param data [Hash{Symbol => Object}]
                # @param comparison_method [String, Symbol]
                # @return [void]
                #
                def initialize(result:, data:, comparison_method: Constants::DEFAULT_COMPARISON_METHOD)
                  @result = result
                  @data = data
                  @comparison_method = comparison_method
                end

                ##
                # @return [Boolean]
                #
                def call
                  casted_data.public_send(comparison_method, result.unsafe_data)
                end

                private

                ##
                # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                #
                def casted_data
                  result.class.data(value: data, result: result)
                end
              end
            end
          end
        end
      end
    end
  end
end
