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
          class ServiceUnstub
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
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceUnstub]
            #
            # @internal
            #   NOTE: `@arguments = nil` means "match any arguments".
            #
            def with_any_arguments(...)
              @arguments = nil

              self
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceUnstub]
            #
            def with_arguments(...)
              @arguments = Support::Arguments.new(...)

              self
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceUnstub]
            #
            def without_arguments
              @arguments = Support::Arguments.null_arguments

              self
            end

            ##
            # @param result_unmock [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock]
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceStub]
            #
            def to(result_unmock)
              @result_unmock = result_unmock.for(service_class, arguments)

              @result_unmock.register

              self
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock]
            #
            def to_return_result_mock
              @result_unmock = Entities::ResultUnmock.new(service_class: service_class, arguments: arguments)
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if service_class != other.service_class
              return false if arguments != other.arguments
              return false if result_unmock != other.result_unmock

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
            # @!attribute [r] result_unmock
            #   @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock]
            #
            attr_reader :result_unmock
          end
        end
      end
    end
  end
end
