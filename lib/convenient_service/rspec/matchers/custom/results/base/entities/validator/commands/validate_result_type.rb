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
                  class ValidateResultType < Support::Command
                    include Support::Delegate
                    include Support::DependencyContainer::Import

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
                    # @return [ConvenientService::Service, Symbol]
                    #
                    delegate :step, to: :chain

                    ##
                    # @return [Boolean]
                    #
                    import :"commands.is_result?", from: Service::Plugins::HasJSendResult::Container

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
                    #   TODO: `commands.IsResult`.
                    #
                    def call
                      return false unless matcher.result

                      commands.is_result?(result)
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
