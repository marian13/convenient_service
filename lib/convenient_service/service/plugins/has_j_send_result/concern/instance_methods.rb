# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Concern
          module InstanceMethods
            ##
            # @api public
            # @raise [ConvenientService::Service::Plugins::HasJSendResult::Errors::ResultIsNotOverridden]
            #
            def result
              raise Errors::ResultIsNotOverridden.new(service: self)
            end

            ##
            # @api public
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   NOTE: Extract to `HasJSendResults`.
            #
            def success(**kwargs)
              self.class.success(**kwargs.merge(service: self))
            end

            ##
            # @api public
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   NOTE: Extract to `HasJSendResults`.
            #
            def failure(**kwargs)
              self.class.failure(**kwargs.merge(service: self))
            end

            ##
            # @api public
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   NOTE: Extract to `HasJSendResults`.
            #
            def error(**kwargs)
              self.class.error(**kwargs.merge(service: self))
            end
          end
        end
      end
    end
  end
end
