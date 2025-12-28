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
          ##
          # @internal
          #   IMPORTANT: Do NOT cache `data`, `message`, and `code` since they can be set multiple times by `with_data`, `and_data`, `with_message`, `and_message`, `with_code`, and `and_code`.
          #
          class ResultUnmock
            ##
            # @param service_class [Class<ConvenientService::Service>]
            # @param arguments [ConvenientService::Support::Arguments]
            # @return [void]
            #
            def initialize(service_class: nil, arguments: nil)
              @service_class = service_class
              @arguments = arguments
            end

            ##
            # @param service_class [Class<ConvenientService::Service>]
            # @param arguments [ConvenientService::Support::Arguments]
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock]
            #
            def for(service_class, arguments)
              self.class.new(service_class: service_class, arguments: arguments)
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock]
            #
            def register
              Commands::DeleteServiceStubbedResult[service: service_class, arguments: arguments]

              self
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock]
            #
            alias_method :apply, :register

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
