# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class MatchResultStatus < Support::Command
                ##
                # @!attribute [r] result
                #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @!attribute [r] statuses
                #   @return [Array<Symbol>]
                #
                attr_reader :statuses

                ##
                # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                # @param statuses [Array<Symbol>]
                # @return [void]
                #
                def initialize(result:, statuses:)
                  @result = result
                  @statuses = statuses
                end

                ##
                # @return [Boolean]
                #
                # @internal
                #   IMPORTANT: Result status is NOT marked as checked intentionally, since it is a mutable operation.
                #
                def call
                  result.status.in?(casted_statuses)
                end

                private

                ##
                # @return [Array<ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status>]
                #
                def casted_statuses
                  statuses.map { |status| result.create_status(status) }
                end
              end
            end
          end
        end
      end
    end
  end
end
