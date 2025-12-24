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
          class UnstubbedService
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
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::UnstubbedService]
            #
            # @internal
            #   NOTE: `@arguments = nil` means "match any arguments".
            #
            def with_any_arguments(...)
              @arguments = nil

              self
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::UnstubbedService]
            #
            def with_arguments(...)
              @arguments = Support::Arguments.new(...)

              self
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::UnstubbedService]
            #
            def without_arguments
              @arguments = Support::Arguments.null_arguments

              self
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::UnstubbedService]
            #
            def to_return_result_mock
              Commands::DeleteServiceStubbedResult[service: service_class, arguments: arguments]

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
          end
        end
      end
    end
  end
end
