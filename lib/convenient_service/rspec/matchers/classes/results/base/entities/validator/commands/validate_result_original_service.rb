# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class Base
            module Entities
              class Validator
                module Commands
                  class ValidateResultOriginalService < Support::Command
                    include Support::Delegate

                    ##
                    # @api private
                    #
                    # @!attribute [r] validator
                    #   @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator]
                    #
                    attr_reader :validator

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
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
                    # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Chain]
                    #
                    delegate :chain, to: :matcher

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service]
                    #
                    delegate :original_service, to: :chain

                    ##
                    # @api private
                    #
                    # @param validator [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator]
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
                    def call
                      return false unless matcher.result
                      return true unless chain.used_original_service?

                      result.original_service.instance_of?(original_service)
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
