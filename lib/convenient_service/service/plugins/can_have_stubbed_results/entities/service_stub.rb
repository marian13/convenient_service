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
            # @param result_spec [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceStub]
            #
            def to(result_spec)
              @result_spec = result_spec.for(service_class, arguments)

              @result_spec.register

              self
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if service_class != other.service_class
              return false if arguments != other.arguments
              return false if result_spec != other.result_spec

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
            # @!attribute [r] result_spec
            #   @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
            #
            attr_reader :result_spec
          end
        end
      end
    end
  end
end
