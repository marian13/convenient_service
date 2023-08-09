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
                  class ValidateResult < Support::Command
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
                    # @return [Boolean]
                    #
                    delegate :valid_result_type?, to: :validator

                    ##
                    # @api private
                    #
                    # @return [Boolean]
                    #
                    delegate :valid_result_status?, to: :validator

                    ##
                    # @api private
                    #
                    # @return [Boolean]
                    #
                    delegate :valid_result_service?, to: :validator

                    ##
                    # @api private
                    #
                    # @return [Boolean]
                    #
                    delegate :valid_result_step?, to: :validator

                    ##
                    # @api private
                    #
                    # @return [Boolean]
                    #
                    delegate :valid_result_data?, to: :validator

                    ##
                    # @api private
                    #
                    # @return [Boolean]
                    #
                    delegate :valid_result_message?, to: :validator

                    ##
                    # @api private
                    #
                    # @return [Boolean]
                    #
                    delegate :valid_result_code?, to: :validator

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
                    # @return [Boolean]
                    # @raise [ConvenientService::RSpec::Matchers::Custom::Results::Base::Exceptions::InvalidStep]
                    #
                    def call
                      validations.all?(true)
                    end

                    private

                    ##
                    # @return [Array<Boolean>]
                    #
                    def validations
                      [
                        valid_result_type?,
                        valid_result_status?,
                        valid_result_service?,
                        valid_result_step?,
                        valid_result_data?,
                        valid_result_message?,
                        valid_result_code?
                      ]
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
