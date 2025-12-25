# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        module Entities
          class ServiceStub
            ##
            # @param service_class [Class<ConvenientService::Service>]
            # @return [void]
            #
            # @internal
            #   NOTE: `@arguments = nil` means "match any arguments".
            #
            def initialize(service_class:)
              @service_class = service_class
              @arguments = nil
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceStub]
            #
            # @internal
            #   NOTE: `@arguments = nil` means "match any arguments".
            #
            def with_any_arguments(...)
              @arguments = nil

              self
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceStub]
            #
            def with_arguments(...)
              @arguments = Support::Arguments.new(...)

              self
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceStub]
            #
            def without_arguments
              @arguments = Support::Arguments.null_arguments

              self
            end

            ##
            # @param result_mock [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceStub]
            #
            def to(result_mock)
              @result_mock = result_mock.for(service_class, arguments)

              @result_mock.register

              self
            end

            ##
            # @param status [Symbol]
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
            #
            def to_return_result(status)
              @result_mock = Entities::ResultMock.new(status: status, service_class: service_class, arguments: arguments)
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
            #
            def to_return_success
              @result_mock = Entities::ResultMock.new(status: :success, service_class: service_class, arguments: arguments)
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
            #
            def to_return_failure
              @result_mock = Entities::ResultMock.new(status: :failure, service_class: service_class, arguments: arguments)
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
            #
            def to_return_error
              @result_mock = Entities::ResultMock.new(status: :error, service_class: service_class, arguments: arguments)
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if service_class != other.service_class
              return false if arguments != other.arguments
              return false if result_mock != other.result_mock

              true
            end

            protected

            ##
            # @!attribute [r] service_class
            #   @return [Class<ConvenientService::Service>]
            #
            attr_reader :service_class

            ##
            # @!attribute [r] arguments
            #   @return [ConvenientService::Support::Arguments]
            #
            attr_reader :arguments

            ##
            # @!attribute [r] result_mock
            #   @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
            #
            attr_reader :result_mock
          end
        end
      end
    end
  end
end
