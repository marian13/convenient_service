# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class MatchResult < Support::Command
                ##
                # @!attribute [r] matcher
                #   @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
                #
                attr_reader :matcher

                ##
                # @!attribute [r] result
                #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @param matcher [ConvenientService::RSpec::Matchers::Custom::Results::Base]
                # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                # @return [void]
                #
                def initialize(matcher:, result:)
                  @matcher = matcher
                  @result = result
                end

                ##
                # @return [Boolean]
                # @raise [ConvenientService::RSpec::Matchers::Custom::Results::Base::Errors::InvalidStep]
                #
                def call
                  rules = []

                  ##
                  # IMPORTANT: Makes `result.class.include?` from the following line idempotent.
                  #
                  result.commit_config!(trigger: Constants::Triggers::BE_RESULT) if result.respond_to?(:commit_config!)

                  rules << ->(result) { Commands::MatchResultType.call(result: result) }
                  rules << ->(result) { Commands::MatchResultStatus.call(result: result, statuses: matcher.statuses) }
                  rules << ->(result) { Commands::MatchResultService.call(result: result, service_class: matcher.service_class) } if matcher.used_of_service?
                  rules << ->(result) { Commands::MatchResultStep.call(result: result, step: matcher.step) } if matcher.used_of_step?
                  rules << ->(result) { Commands::MatchResultData.call(result: result, data: matcher.data, comparison_method: matcher.comparison_method) } if matcher.used_data?
                  rules << ->(result) { Commands::MatchResultMessage.call(result: result, message: matcher.message, comparison_method: matcher.comparison_method) } if matcher.used_message?
                  rules << ->(result) { Commands::MatchResultCode.call(result: result, code: matcher.code, comparison_method: matcher.comparison_method) } if matcher.used_code?

                  condition = Utils::Proc.conjunct(rules)

                  condition.call(result)
                end
              end
            end
          end
        end
      end
    end
  end
end
