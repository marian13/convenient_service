# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            # @raise [ConvenientService::Service::Plugins::HasResult::Exceptions::ResultIsNotOverridden]
            #
            def result(...)
              new(...).result
            end
          end

          instance_methods do
            ##
            # @api public
            # @raise [ConvenientService::Service::Plugins::HasResult::Exceptions::ResultIsNotOverridden]
            #
            def result
              raise Exceptions::ResultIsNotOverridden.new(service: self)
            end
          end
        end
      end
    end
  end
end
