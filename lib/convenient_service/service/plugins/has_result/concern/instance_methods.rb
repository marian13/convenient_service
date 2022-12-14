# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Concern
          module InstanceMethods
            ##
            # @api public
            # @raise [ConvenientService::Service::Plugins::HasResult::Errors::ResultIsNotOverridden]
            #
            def result
              raise Errors::ResultIsNotOverridden.new(service: self)
            end

            ##
            # @api public
            # @param kwargs [Hash]
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
            #
            def success(**kwargs)
              self.class.success(**kwargs.merge(service: self))
            end

            ##
            # @api public
            # @param kwargs [Hash]
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
            #
            def failure(**kwargs)
              self.class.failure(**kwargs.merge(service: self))
            end

            ##
            # @api public
            # @param kwargs [Hash]
            # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
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
