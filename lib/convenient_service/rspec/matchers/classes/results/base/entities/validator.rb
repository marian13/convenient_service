# frozen_string_literal: true

require_relative "validator/commands"

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class Base
            module Entities
              class Validator
                ##
                # @api private
                #
                # @!attribute [r] matcher
                #   @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
                #
                attr_reader :matcher

                ##
                # @api private
                #
                # @param matcher [ConvenientService::RSpec::Matchers::Classes::Results::Base]
                # @return [void]
                #
                def initialize(matcher:)
                  @matcher = matcher
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def valid_result?
                  Commands::ValidateResult[validator: self]
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def valid_result_code?
                  Commands::ValidateResultCode[validator: self]
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def valid_result_data?
                  Commands::ValidateResultData[validator: self]
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def valid_result_message?
                  Commands::ValidateResultMessage[validator: self]
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def valid_result_service?
                  Commands::ValidateResultService[validator: self]
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def valid_result_status?
                  Commands::ValidateResultStatus[validator: self]
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def valid_result_step?
                  Commands::ValidateResultStep[validator: self]
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def valid_result_type?
                  Commands::ValidateResultType[validator: self]
                end

                ##
                # @api private
                #
                # @param other [Object] Can be any type.
                # @return [Boolean, nil]
                #
                def ==(other)
                  return nil unless other.instance_of?(self.class)

                  return false if matcher != other.matcher

                  true
                end
              end
            end
          end
        end
      end
    end
  end
end
