# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            #
            # Allows to pass a value to `in` method without its intermediate processing.
            # @see https://userdocs.convenientservice.org/basics/step_to_result_translation_table
            #
            # @example `:chat_v2` is passed to `AssertFeatureEnabled` as it is.
            #   step AssertFeatureEnabled, in: {name: raw(:chat_v2)}
            #   # that is converted to the following service invocation:
            #   AssertFeatureEnabled.result(name: :chat_v2)
            #
            # @param value [Object] Can be any type.
            # @return [ConvenientService::Support::RawValue]
            #
            def raw(value)
              Support::RawValue.wrap(value)
            end

            ##
            # @api public
            #
            # @param method_name [String, Symbol]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Values::Reassignment]
            #
            def reassign(method_name)
              Entities::Method::Entities::Values::Reassignment.new(method_name)
            end

            ##
            # @api private
            #
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def step_class
              @step_class ||= Commands::CreateStepClass.call(service_class: self)
            end
          end
        end
      end
    end
  end
end
