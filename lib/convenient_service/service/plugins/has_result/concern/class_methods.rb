# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Concern
          module ClassMethods
            ##
            # @api public
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
            #
            def result(...)
              new(...).result
            end

            ##
            # @api private
            #
            # @internal
            #   - https://ruby-doc.org/core-2.5.0/Class.html#method-i-allocate
            #   - https://frontdeveloper.pl/2018/11/ruby-allocate-method/
            #
            #   TODO: Custom YARD type for service instance, service class as return values.
            #   TODO: Extract into separate plugin.
            #
            def new_without_initialize
              allocate
            end

            ##
            # @api private
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
            #
            # @internal
            #   NOTE: This method is internally used by custom RSpec helper `stub_service`. It should NOT be used in the client code.
            #
            def success(
              service: Constants::DEFAULT_SERVICE_INSTANCE,
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
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
            #
            # @internal
            #   NOTE: This method is internally used by custom RSpec helper `stub_service`. It should NOT be used in the client code.
            #
            def failure(
              service: Constants::DEFAULT_SERVICE_INSTANCE,
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
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
            #
            # @internal
            #   NOTE: This method is internally used by custom RSpec helper `stub_service`. It should NOT be used in the client code.
            #
            def error(
              service: Constants::DEFAULT_SERVICE_INSTANCE,
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
            def result_class
              @result_class ||= Commands::CreateResultClass.call(service_class: self)
            end
          end
        end
      end
    end
  end
end
