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
                  class ValidateResultStep < Support::Command
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
                    # @return [ConvenientService::Service, Symbol]
                    #
                    delegate :step, to: :chain

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
                    # @raise [ConvenientService::RSpec::Matchers::Custom::Results::Base::Exceptions::InvalidStep]
                    #
                    # @internal
                    #   TODO: Import via commands.
                    #
                    def call
                      return true unless chain.used_step?

                      case step
                      when ::Class then match_service_step?
                      when :result then match_result_method_step?
                      when ::Symbol then match_method_step?
                      when nil then match_without_step?
                      else raise Exceptions::InvalidStep.new(step: step)
                      end
                    end

                    private

                    ##
                    # @return [Boolean]
                    #
                    def match_service_step?
                      return false unless result.step

                      result.step.service_class == step
                    end

                    ##
                    # @return [Boolean]
                    #
                    def match_result_method_step?
                      return false unless result.step

                      result.step.result_step?
                    end

                    ##
                    # @return [Boolean]
                    #
                    def match_method_step?
                      return false unless result.step&.method_step?

                      result.step.method.to_sym == step
                    end

                    ##
                    # @return [Boolean]
                    #
                    def match_without_step?
                      result.step.nil?
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
