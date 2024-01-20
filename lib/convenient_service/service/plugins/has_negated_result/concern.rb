# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasNegatedResult
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            # @raise [ConvenientService::Service::Plugins::HasNegatedResult::Exceptions::NegatedResultIsNotOverridden]
            #
            def negated_result(...)
              new(...).negated_result
            end
          end

          instance_methods do
            ##
            # @api public
            # @raise [ConvenientService::Service::Plugins::HasNegatedResult::Exceptions::NegatedResultIsNotOverridden]
            #
            def negated_result
              ::ConvenientService.raise Exceptions::NegatedResultIsNotOverridden.new(service: self)
            end
          end
        end
      end
    end
  end
end
