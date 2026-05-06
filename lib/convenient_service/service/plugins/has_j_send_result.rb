# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "has_j_send_result/concern"
require_relative "has_j_send_result/constants"
require_relative "has_j_send_result/entities"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        class << self
          ##
          # @return [Symbol]
          #
          def success_status
            Constants::SUCCESS_STATUS
          end

          ##
          # @return [Symbol]
          #
          def failure_status
            Constants::FAILURE_STATUS
          end

          ##
          # @return [Symbol]
          #
          def error_status
            Constants::ERROR_STATUS
          end

          ##
          # @return [Hash{Symbol => Object}]
          #
          def default_success_data
            Constants::DEFAULT_SUCCESS_DATA
          end

          ##
          # @return [Hash{Symbol => Object}]
          #
          def default_failure_data
            Constants::DEFAULT_FAILURE_DATA
          end

          ##
          # @return [Hash{Symbol => Object}]
          #
          def default_error_data
            Constants::DEFAULT_ERROR_DATA
          end

          ##
          # @return [String]
          #
          def default_success_message
            Constants::DEFAULT_SUCCESS_MESSAGE
          end

          ##
          # @return [String]
          #
          def default_failure_message
            Constants::DEFAULT_FAILURE_MESSAGE
          end

          ##
          # @return [String]
          #
          def default_error_message
            Constants::DEFAULT_ERROR_MESSAGE
          end

          ##
          # @return [Symbol]
          #
          def default_success_code
            Constants::DEFAULT_SUCCESS_CODE
          end

          ##
          # @return [Symbol]
          #
          def default_failure_code
            Constants::DEFAULT_FAILURE_CODE
          end

          ##
          # @return [Symbol]
          #
          def default_error_code
            Constants::DEFAULT_ERROR_CODE
          end

          ##
          # Checks whether an object is a result class.
          #
          # @api public
          #
          # @param result_class [Object] Can be any type.
          # @return [Boolean]
          #
          # @example Simple usage.
          #   class Service
          #     include ConvenientService::Standard::Config
          #
          #     def result
          #       success
          #     end
          #   end
          #
          #   result = Service.result
          #
          #   ConvenientService::Plugins::Service::HasJSendResult.result_class?(result.class)
          #   # => true
          #
          #   ConvenientService::Plugins::Service::HasJSendResult.result_class?(result)
          #   # => false
          #
          #   ConvenientService::Plugins::Service::HasJSendResult.result_class?(42)
          #   # => false
          #
          def result_class?(result_class)
            return false unless result_class.instance_of?(::Class)

            result_class.include?(Entities::Result::Concern)
          end

          ##
          # Checks whether an object is a result instance.
          #
          # @api public
          #
          # @param result [Object] Can be any type.
          # @return [Boolean]
          #
          # @example Simple usage.
          #   class Service
          #     include ConvenientService::Standard::Config
          #
          #     def result
          #       success
          #     end
          #   end
          #
          #   result = Service.result
          #
          #   ConvenientService::Plugins::Service::HasJSendResult.result?(result)
          #   # => true
          #
          #   ConvenientService::Plugins::Service::HasJSendResult.result?(result.class)
          #   # => false
          #
          #   ConvenientService::Plugins::Service::HasJSendResult.result?(42)
          #   # => false
          #
          def result?(result)
            result_class?(result.class)
          end
        end
      end
    end
  end
end
