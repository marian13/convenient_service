# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "standard/commands"

require_relative "standard/v1"
require_relative "standard/aliases"

module ConvenientService
  module Service
    module Configs
      ##
      # Default configuration for the user-defined services.
      #
      module Standard
        include ConvenientService::Config

        default_options do
          [
            :essential,
            :callbacks,
            :fallbacks,
            # :rollbacks,
            # :fault_tolerance,
            :inspect,
            :recalculation,
            :result_parents_trace,
            :code_review_automation,
            :short_syntax,
            :type_safety,
            :exception_services_trace,
            :per_instance_caching,
            :backtrace_cleaner,
            # :active_model_attribute_assignment,
            # :dry_initializer,
            # :active_model_attributes,
            # :active_model_validations,
            # :dry_validation,
            # :memo_wise,
            # :not_passed_arguments,
            # :finite_loop,
            rspec: Dependencies.rspec.loaded?
          ]
        end

        ##
        # @internal
        #   IMPORTANT: Order of plugins matters.
        #
        #   NOTE: `class_exec` (that is used under the hood by `included`) defines `class Result` in the global namespace.
        #   That is why `entity :Result do` is used.
        #   - https://stackoverflow.com/a/51965126/12201472
        #
        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include ConvenientService::Service::Core

          concerns do
            use ConvenientService::Plugins::Service::CanHaveStubbedResults::Concern if options.enabled?(:rspec)
            use ConvenientService::Plugins::Common::HasInternals::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Common::HasConstructor::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Service::HasResult::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Service::HasJSendResult::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Service::HasNegatedResult::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Service::HasNegatedJSendResult::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Service::CanHaveSteps::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Service::CanHaveConnectedSteps::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Service::CanHaveStepAwareEnumerables::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Service::CanBeCalled::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Common::CanHaveCallbacks::Concern if options.enabled?(:callbacks)
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Concern if options.enabled?(:fallbacks)
            use ConvenientService::Plugins::Service::HasInspect::Concern if options.enabled?(:inspect)
            use ConvenientService::Plugins::Service::HasAwesomePrintInspect::Concern if options.enabled?(:awesome_print_inspect)
            use ConvenientService::Plugins::Service::HasAmazingPrintInspect::Concern if options.enabled?(:amazing_print_inspect)
            use ConvenientService::Plugins::Common::CachesConstructorArguments::Concern if options.enabled?(:recalculation)
            use ConvenientService::Plugins::Common::CanBeCopied::Concern if options.enabled?(:recalculation)
            use ConvenientService::Plugins::Service::CanHaveRecalculations::Concern if options.enabled?(:recalculation)
            use ConvenientService::Plugins::Service::CanNotBeInherited::Concern if options.enabled?(:code_review_automation)
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Concern if options.enabled?(:short_syntax)
            use ConvenientService::Plugins::Service::HasJSendResultStatusCheckShortSyntax::Concern if options.enabled?(:short_syntax)
            use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern if options.enabled?(:active_model_attribute_assignment)
            use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern if options.enabled?(:dry_initializer)
            use ConvenientService::Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern if options.enabled?(:active_model_attributes)
            use ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern if options.enabled?(:active_model_validations)
            use ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Concern if options.enabled?(:dry_validation)
            use ConvenientService::Plugins::Common::HasMemoization::UsingMemoWise::Concern if options.enabled?(:memo_wise)
            use ConvenientService::Plugins::Common::CanHaveNotPassedArguments::Concern if options.enabled?(:not_passed_arguments)
            use ConvenientService::Plugins::Common::CanUtilizeFiniteLoop::Concern if options.enabled?(:finite_loop)
          end

          middlewares :initialize do
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware if options.enabled?(:exception_services_trace)
            use ConvenientService::Plugins::Common::CachesConstructorArguments::Middleware if options.enabled?(:recalculation)
            use ConvenientService::Plugins::Common::CleansExceptionBacktrace::Middleware if options.enabled?(:backtrace_cleaner)
            use ConvenientService::Plugins::Service::CanHaveSteps::Middleware if options.enabled?(:essential)
            use ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware if options.enabled?(:active_model_attribute_assignment)
            use ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Middleware if options.enabled?(:code_review_automation)
          end

          middlewares :result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware if options.enabled?(:exception_services_trace)
            use ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware if options.enabled?(:rspec)
            use ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware if options.enabled?(:callbacks)
            use ConvenientService::Service::Plugins::CanHaveRollbacks::Middleware if options.enabled?(:rollbacks)
            use ConvenientService::Plugins::Service::SetsParentToForeignResult::Middleware if options.enabled?(:result_parents_trace)
            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware if options.enabled?(:type_safety)
            use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware if options.enabled?(:fault_tolerance)
            use ConvenientService::Plugins::Common::CleansExceptionBacktrace::Middleware if options.enabled?(:backtrace_cleaner)
            use ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Middleware if options.enabled?(:active_model_validations)
            use ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Middleware if options.enabled?(:dry_validation)
            use ConvenientService::Plugins::Service::CanHaveConnectedSteps::Middleware if options.enabled?(:essential)
          end

          middlewares :negated_result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware if options.enabled?(:exception_services_trace)
            use ConvenientService::Plugins::Common::EnsuresNegatedJSendResult::Middleware if options.enabled?(:essential)
            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware if options.enabled?(:type_safety)
            use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware if options.enabled?(:fault_tolerance)
            use ConvenientService::Plugins::Common::CleansExceptionBacktrace::Middleware if options.enabled?(:backtrace_cleaner)
          end

          middlewares :regular_result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
          end

          middlewares :steps_result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
          end

          middlewares :fallback_failure_result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware if options.enabled?(:exception_services_trace)
            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware if options.enabled?(:type_safety)
            # use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware if options.enabled?(:fault_tolerance) # TODO: Dedicted `rescue`?
            use ConvenientService::Plugins::Common::CleansExceptionBacktrace::Middleware if options.enabled?(:backtrace_cleaner)
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :failure) if options.enabled?(:fallbacks)
          end

          middlewares :fallback_error_result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware if options.enabled?(:exception_services_trace)
            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware if options.enabled?(:type_safety)
            # use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware if options.enabled?(:fault_tolerance) # TODO: Dedicted `rescue`?
            use ConvenientService::Plugins::Common::CleansExceptionBacktrace::Middleware if options.enabled?(:backtrace_cleaner)
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :error) if options.enabled?(:fallbacks)
          end

          middlewares :fallback_result do
            use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
            use ConvenientService::Plugins::Service::CollectsServicesInException::Middleware if options.enabled?(:exception_services_trace)
            use ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware if options.enabled?(:type_safety)
            # use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware if options.enabled?(:fault_tolerance) # TODO: Dedicted `rescue`?
            use ConvenientService::Plugins::Common::CleansExceptionBacktrace::Middleware if options.enabled?(:backtrace_cleaner)
            use ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: nil) if options.enabled?(:fallbacks)
          end

          middlewares :success do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Success::Middleware if options.enabled?(:short_syntax)
          end

          middlewares :failure do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Failure::Middleware if options.enabled?(:short_syntax)
          end

          middlewares :error do
            use ConvenientService::Plugins::Service::HasJSendResultShortSyntax::Error::Middleware if options.enabled?(:short_syntax)
          end

          middlewares :result, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveStubbedResults::Middleware if options.enabled?(:rspec)
            use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware if options.enabled?(:fault_tolerance)
          end

          middlewares :before, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveBeforeStepCallbacks::Middleware if options.enabled?(:callbacks)
          end

          middlewares :around, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveAroundStepCallbacks::Middleware if options.enabled?(:callbacks)
          end

          middlewares :after, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveAfterStepCallbacks::Middleware if options.enabled?(:callbacks)
          end

          entity :Result do
            concerns do
              use ConvenientService::Plugins::Common::HasInternals::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Common::HasConstructor::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Result::HasJSendStatusAndAttributes::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Result::CanHaveStep::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Result::CanBeCalled::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Result::HasNegatedResult::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Result::HasPatternMatchingSupport::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Result::CanBeFromFallback::Concern if options.enabled?(:fallbacks)
              use ConvenientService::Plugins::Result::CanHaveFallbacks::Concern if options.enabled?(:fallbacks)
              use ConvenientService::Plugins::Result::CanBeFromException::Concern if options.enabled?(:fault_tolerance)
              use ConvenientService::Plugins::Result::HasInspect::Concern if options.enabled?(:inspect)
              use ConvenientService::Plugins::Result::HasAwesomePrintInspect::Concern if options.enabled?(:awesome_print_inspect)
              use ConvenientService::Plugins::Result::HasAmazingPrintInspect::Concern if options.enabled?(:amazing_print_inspect)
              use ConvenientService::Plugins::Result::CanBeOwnResult::Concern if options.enabled?(:result_parents_trace)
              use ConvenientService::Plugins::Result::CanHaveParentResult::Concern if options.enabled?(:result_parents_trace)
              use ConvenientService::Plugins::Result::CanBeStubbedResult::Concern if options.enabled?(:rspec)
              use ConvenientService::Plugins::Result::CanHaveCheckedStatus::Concern if options.enabled?(:code_review_automation)
              use ConvenientService::Plugins::Common::HasJSendResultDuckShortSyntax::Concern if options.enabled?(:short_syntax)
              # use ConvenientService::Plugins::Result::HelpsToLearnSimilaritiesWithCommonObjects::Concern
            end

            middlewares :initialize do
              use ConvenientService::Plugins::Result::HasJSendStatusAndAttributes::Middleware if options.enabled?(:essential)
            end

            middlewares :negated_result do
              use ConvenientService::Plugins::Common::EnsuresNegatedJSendResult::Middleware if options.enabled?(:essential)
            end

            middlewares :data do
              use ConvenientService::Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware if options.enabled?(:code_review_automation)
            end

            middlewares :message do
              use ConvenientService::Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware if options.enabled?(:code_review_automation)
            end

            middlewares :code do
              use ConvenientService::Plugins::Result::RaisesOnNotCheckedResultStatus::Middleware if options.enabled?(:code_review_automation)
            end

            entity :Status do
              concerns do
                use ConvenientService::Plugins::Common::HasInternals::Concern if options.enabled?(:essential)
                use ConvenientService::Plugins::Status::HasInspect::Concern if options.enabled?(:inspect)
                use ConvenientService::Plugins::Status::HasAwesomePrintInspect::Concern if options.enabled?(:awesome_print_inspect)
                use ConvenientService::Plugins::Status::HasAmazingPrintInspect::Concern if options.enabled?(:amazing_print_inspect)
                use ConvenientService::Plugins::Status::CanBeChecked::Concern if options.enabled?(:code_review_automation)
              end

              middlewares :success? do
                use ConvenientService::Plugins::Status::CanBeChecked::Middleware if options.enabled?(:code_review_automation)
              end

              middlewares :failure? do
                use ConvenientService::Plugins::Status::CanBeChecked::Middleware if options.enabled?(:code_review_automation)
              end

              middlewares :error? do
                use ConvenientService::Plugins::Status::CanBeChecked::Middleware if options.enabled?(:code_review_automation)
              end

              middlewares :not_success? do
                use ConvenientService::Plugins::Status::CanBeChecked::Middleware if options.enabled?(:code_review_automation)
              end

              middlewares :not_failure? do
                use ConvenientService::Plugins::Status::CanBeChecked::Middleware if options.enabled?(:code_review_automation)
              end

              middlewares :not_error? do
                use ConvenientService::Plugins::Status::CanBeChecked::Middleware if options.enabled?(:code_review_automation)
              end

              entity :Internals do
                concerns do
                  use ConvenientService::Plugins::Internals::HasCache::Concern if options.enabled?(:per_instance_caching)
                end
              end
            end

            entity :Data do
              concerns do
                use ConvenientService::Plugins::Data::HasInspect::Concern if options.enabled?(:inspect)
                use ConvenientService::Plugins::Data::HasAwesomePrintInspect::Concern if options.enabled?(:awesome_print_inspect)
                use ConvenientService::Plugins::Data::HasAmazingPrintInspect::Concern if options.enabled?(:amazing_print_inspect)
              end

              middlewares :initialize do
                use ConvenientService::Plugins::Data::HasMethodReaders::Middleware if options.enabled?(:short_syntax)
              end
            end

            entity :Message do
              concerns do
                use ConvenientService::Plugins::Message::HasInspect::Concern if options.enabled?(:inspect)
                use ConvenientService::Plugins::Message::HasAwesomePrintInspect::Concern if options.enabled?(:awesome_print_inspect)
                use ConvenientService::Plugins::Message::HasAmazingPrintInspect::Concern if options.enabled?(:amazing_print_inspect)
              end
            end

            entity :Code do
              concerns do
                use ConvenientService::Plugins::Code::HasInspect::Concern if options.enabled?(:inspect)
                use ConvenientService::Plugins::Code::HasAwesomePrintInspect::Concern if options.enabled?(:awesome_print_inspect)
                use ConvenientService::Plugins::Code::HasAmazingPrintInspect::Concern if options.enabled?(:amazing_print_inspect)
              end
            end

            entity :Internals do
              concerns do
                use ConvenientService::Plugins::Internals::HasCache::Concern if options.enabled?(:per_instance_caching)
              end
            end
          end

          entity :Step do
            concerns do
              use ConvenientService::Plugins::Common::HasInternals::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Step::HasResult::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Step::CanBeCompleted::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Step::CanBeServiceStep::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Step::CanBeMethodStep::Concern if options.enabled?(:essential)
              use ConvenientService::Plugins::Common::CanHaveCallbacks::Concern if options.enabled?(:callbacks)
              use ConvenientService::Plugins::Step::CanHaveFallbacks::Concern if options.enabled?(:fallbacks)
              use ConvenientService::Plugins::Step::HasInspect::Concern if options.enabled?(:inspect)
              use ConvenientService::Plugins::Step::HasAwesomePrintInspect::Concern if options.enabled?(:awesome_print_inspect)
              use ConvenientService::Plugins::Step::HasAmazingPrintInspect::Concern if options.enabled?(:amazing_print_inspect)
              use ConvenientService::Plugins::Common::HasJSendResultDuckShortSyntax::Concern if options.enabled?(:short_syntax)
            end

            middlewares :result do
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
              use ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware if options.enabled?(:callbacks)
              use ConvenientService::Plugins::Step::HasResult::Middleware if options.enabled?(:essential)
              use ConvenientService::Plugins::Step::CanHaveParentResult::Middleware if options.enabled?(:result_parents_trace)
              use ConvenientService::Plugins::Step::CanHaveFallbacks::Middleware.with(fallback_true_status: :failure) if options.enabled?(:fallbacks)
              use ConvenientService::Plugins::Step::RaisesOnNotResultReturnValue::Middleware if options.enabled?(:type_safety)
              use ConvenientService::Plugins::Step::CanBeServiceStep::Middleware if options.enabled?(:essential)
              use ConvenientService::Plugins::Step::CanBeMethodStep::Middleware if options.enabled?(:essential)
            end

            middlewares :method_result do
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
            end

            middlewares :service_result do
              use ConvenientService::Plugins::Common::CachesReturnValue::Middleware if options.enabled?(:per_instance_caching)
            end

            entity :Internals do
              concerns do
                use ConvenientService::Plugins::Internals::HasCache::Concern if options.enabled?(:per_instance_caching)
              end
            end
          end

          entity :Internals do
            concerns do
              use ConvenientService::Plugins::Internals::HasCache::Concern if options.enabled?(:per_instance_caching)
            end
          end

          ##
          # TODO: Rewrite. This plugin does NOT do what it states. Probably I was NOT with a clear mind while writing it (facepalm).
          #
          # middlewares :result do
          #   use ConvenientService::Plugins::Service::RaisesOnDoubleResult::Middleware
          # end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock

        class << self
          ##
          # Checks whether a class is a service class.
          #
          # @api public
          #
          # @param service_class [Object] Can be any type.
          # @return [Boolean]
          #
          # @example Simple usage.
          #   class Service
          #     include ConvenientService::Standard::Config
          #
          #     def result
          #       success
          #     end
          #   end
          #
          #   ConvenientService::Service::Configs::Standard.service_class?(Service)
          #   # => true
          #
          #   ConvenientService::Service::Configs::Standard.service_class?(42)
          #   # => false
          #
          def service_class?(service_class)
            Commands::IsServiceClass[service_class: service_class]
          end

          ##
          # Checks whether an object is a service instance.
          #
          # @api public
          #
          # @param service [Object] Can be any type.
          # @return [Boolean]
          #
          # @example Simple usage.
          #   class Service
          #     include ConvenientService::Standard::Config
          #
          #     def result
          #       success
          #     end
          #   end
          #
          #   service = Service.new
          #
          #   ConvenientService::Service::Configs::Standard.service?(service)
          #   # => true
          #
          #   ConvenientService::Service::Configs::Standard.service?(42)
          #   # => false
          #
          def service?(service)
            Commands::IsService[service: service]
          end
        end
      end
    end
  end
end
