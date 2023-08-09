# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Entities
              class Validator
                module Commands
                  class ValidateResultStatus < Support::Command
                    include Support::Delegate

                    ##
                    # @api private
                    #
                    # @!attribute [r] validator
                    #   @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Validator]
                    #
                    attr_reader :validator

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base]
                    #
                    delegate :matcher, to: :validator

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    delegate :result, to: :matcher

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Chain]
                    #
                    delegate :chain, to: :matcher

                    ##
                    # @api private
                    #
                    # @return [Array<Symbol>]
                    #
                    delegate :statuses, to: :chain

                    ##
                    # @api private
                    #
                    # @param validator [ConvenientService::RSpec::Matchers::Custom::Results::Base::Entities::Validator]
                    # @return [void]
                    #
                    def initialize(validator:)
                      @validator = validator
                    end

                    ##
                    # @api private
                    #
                    # @return [Boolean]
                    #
                    # @internal
                    #   IMPORTANT: Result status is NOT marked as checked intentionally, since it is a mutable operation.
                    #
                    def call
                      return false unless matcher.result

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
  end
end
