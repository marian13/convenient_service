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
                  class ValidateResult < Support::Command
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
                    delegate :valid_result_original_service?, to: :validator

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
                    # @raise [ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions::InvalidStep]
                    #
                    def call
                      validations.all?(true)
                    end

                    private

                    ##
                    # @return [Enumerator]
                    #
                    # @internal
                    #   NOTE: `Enumerator` is used to delay validations till the last moment.
                    #   NOTE: `Enumerator` is used to skip following validations if the previous validation is NOT satisfied.
                    #
                    def validations
                      ::Enumerator.new do |yielder|
                        yielder.yield(valid_result_type?)
                        yielder.yield(valid_result_status?)
                        yielder.yield(valid_result_service?)
                        yielder.yield(valid_result_original_service?)
                        yielder.yield(valid_result_step?)
                        yielder.yield(valid_result_data?)
                        yielder.yield(valid_result_message?)
                        yielder.yield(valid_result_code?)
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
end
