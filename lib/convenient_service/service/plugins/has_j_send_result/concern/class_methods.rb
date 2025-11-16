# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Concern
          module ClassMethods
            ##
            # @api private
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   NOTE: This method is internally used by custom RSpec helper `stub_service`. It should NOT be used in the client code.
            #
            def success(
              service: new_without_initialize,
              data: Constants::DEFAULT_SUCCESS_DATA,
              message: Constants::DEFAULT_SUCCESS_MESSAGE,
              code: Constants::DEFAULT_SUCCESS_CODE
            )
              result_class.new(
                service: service,
                status: Constants::SUCCESS_STATUS,
                data: data,
                message: message,
                code: code
              )
            end

            ##
            # @api private
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   NOTE: This method is internally used by custom RSpec helper `stub_service`. It should NOT be used in the client code.
            #
            def failure(
              service: new_without_initialize,
              data: Constants::DEFAULT_FAILURE_DATA,
              message: Constants::DEFAULT_FAILURE_MESSAGE,
              code: Constants::DEFAULT_FAILURE_CODE
            )
              result_class.new(
                service: service,
                status: Constants::FAILURE_STATUS,
                data: data,
                message: message,
                code: code
              )
            end

            ##
            # @api private
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   NOTE: This method is internally used by custom RSpec helper `stub_service`. It should NOT be used in the client code.
            #
            def error(
              service: new_without_initialize,
              data: Constants::DEFAULT_ERROR_DATA,
              message: Constants::DEFAULT_ERROR_MESSAGE,
              code: Constants::DEFAULT_ERROR_CODE
            )
              result_class.new(
                service: service,
                status: Constants::ERROR_STATUS,
                data: data,
                message: message,
                code: code
              )
            end

            ##
            # @api private
            # @return [Class]
            #
            # @internal
            #   TODO: Specs that prevent public interface accidental pollution.
            #
            def result_class
              @result_class ||= Common::Plugins::CanHaveUserProvidedEntity.find_or_create_entity(self, Entities::Result)
            end
          end
        end
      end
    end
  end
end
