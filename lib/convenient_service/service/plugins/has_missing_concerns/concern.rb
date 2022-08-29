# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasMissingConcerns
        module Concern
          include Support::Concern

          instance_methods do
            include Support::Dependency

            dependency :internals, from: Common::Plugins::HasInternals::Concern

            dependency :initialize, from: Common::Plugins::HasConstructor::Concern

            dependency :constructor_params, from: Common::Plugins::CachesConstructorParams::Concern

            dependency :copy, from: Common::Plugins::CanBeCopied::Concern
            dependency :to_args, from: Common::Plugins::CanBeCopied::Concern
            dependency :to_kwargs, from: Common::Plugins::CanBeCopied::Concern
            dependency :to_block, from: Common::Plugins::CanBeCopied::Concern

            dependency :result, from: Service::Plugins::HasResult::Concern

            dependency :steps, from: Service::Plugins::HasResultSteps::Concern

            dependency :recalculate_result, from: Service::Plugins::CanRecalculateResult::Concern

            dependency :callbacks, from: Common::Plugins::HasCallbacks::Concern
          end

          class_methods do
            include Support::Dependency

            dependency :internals_class, from: Common::Plugins::HasInternals::Concern

            dependency :result, from: Service::Plugins::HasResult::Concern
            dependency :success, from: Service::Plugins::HasResult::Concern
            dependency :failure, from: Service::Plugins::HasResult::Concern
            dependency :error, from: Service::Plugins::HasResult::Concern
            dependency :result_class, from: Service::Plugins::HasResult::Concern

            dependency :[], from: Service::Plugins::HasResultShortSyntax::Concern

            dependency :step, from: Service::Plugins::HasResultSteps::Concern
            dependency :raw, from: Service::Plugins::HasResultSteps::Concern
            dependency :steps, from: Service::Plugins::HasResultSteps::Concern
            dependency :step_class, from: Service::Plugins::HasResultSteps::Concern

            dependency :callbacks, from: Common::Plugins::HasCallbacks::Concern
            dependency :before, from: Common::Plugins::HasCallbacks::Concern
            dependency :after, from: Common::Plugins::HasCallbacks::Concern

            dependency :around, from: Common::Plugins::HasAroundCallbacks::Concern
          end
        end
      end
    end
  end
end
