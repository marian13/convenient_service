# frozen_string_literal: true

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
            #   TODO: Is it OK to pass custom `message`, `code` to `success`? Why?
            #   NOTE: Extract to `HasJSendResults`.
            #
            def success(
              service: new_without_initialize,
              data: Constants::DEFAULT_SUCCESS_DATA
            )
              result_class.new(
                service: service,
                status: Constants::SUCCESS_STATUS,
                data: data,
                message: Constants::SUCCESS_MESSAGE,
                code: Constants::SUCCESS_CODE
              )
            end

            ##
            # @api private
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   NOTE: This method is internally used by custom RSpec helper `stub_service`. It should NOT be used in the client code.
            #
            #   TODO: Is it OK to pass custom `code` to `failure`? Why?
            #   NOTE: Extract to `HasJSendResults`.
            #
            #   TODO: `data.first.join(" ")` is duplicated in `be_result` matcher.
            #
            def failure(
              service: new_without_initialize,
              data: Constants::DEFAULT_FAILURE_DATA,
              message: data.any? ? data.first.join(" ") : Constants::DEFAULT_FAILURE_MESSAGE
            )
              result_class.new(
                service: service,
                status: Constants::FAILURE_STATUS,
                data: data,
                message: message,
                code: Constants::FAILURE_CODE
              )
            end

            ##
            # @api private
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   NOTE: This method is internally used by custom RSpec helper `stub_service`. It should NOT be used in the client code.
            #
            #   TODO: Is it OK to pass custom `data` to `error`? Why?
            #   NOTE: Extract to `HasJSendResults`.
            #
            def error(
              service: new_without_initialize,
              message: Constants::DEFAULT_ERROR_MESSAGE,
              code: Constants::DEFAULT_ERROR_CODE
            )
              result_class.new(
                service: service,
                status: Constants::ERROR_STATUS,
                data: Constants::ERROR_DATA,
                message: message,
                code: code
              )
            end

            ##
            # @api private
            # @return [Class]
            #
            # @internal
            #   NOTE: A command instead of `import` is used in order to NOT pollute the public interface.
            #   TODO: Specs that prevent public interface accidental pollution.
            #
            def result_class
              @result_class ||= Commands::CreateResultClass.call(service_class: self)
            end
          end
        end
      end
    end
  end
end
