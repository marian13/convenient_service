# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

##
# NOTE: This file checks only half of `ConvenientService::Service::Configs::Standard` functionality.
# The rest is verified by `test/lib/convenient_service/service/configs/standard_test.rb`.
#
# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/MultipleDescribes
RSpec.describe ConvenientService::Service::Configs::Standard, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Config) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Service::Core) }

      example_group "service" do
        example_group "concerns" do
          let(:concerns) do
            [
              ConvenientService::Service::Plugins::CanHaveStubbedResults::Concern,
              ConvenientService::Common::Plugins::HasInternals::Concern,
              ConvenientService::Common::Plugins::HasConstructor::Concern,
              ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern,
              ConvenientService::Service::Plugins::HasResult::Concern,
              ConvenientService::Service::Plugins::HasJSendResult::Concern,
              ConvenientService::Service::Plugins::HasNegatedResult::Concern,
              ConvenientService::Service::Plugins::HasNegatedJSendResult::Concern,
              ConvenientService::Service::Plugins::CanHaveSteps::Concern,
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Concern,
              ConvenientService::Common::Plugins::CanHaveCallbacks::Concern,
              ConvenientService::Service::Plugins::CanHaveFallbacks::Concern,
              ConvenientService::Service::Plugins::HasInspect::Concern,
              ConvenientService::Common::Plugins::CachesConstructorArguments::Concern,
              ConvenientService::Common::Plugins::CanBeCopied::Concern,
              ConvenientService::Service::Plugins::CanHaveRecalculations::Concern,
              ConvenientService::Service::Plugins::CanNotBeInherited::Concern,
              ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Concern,
              ConvenientService::Service::Plugins::HasJSendResultStatusCheckShortSyntax::Concern,
              ConvenientService::Service::Plugins::HasMermaidFlowchart::Concern
            ]
          end

          it "sets service concerns" do
            expect(service_class.concerns.to_a).to eq(concerns)
          end
        end

        example_group "#initialize middlewares" do
          let(:initialize_middlewares) do
            [
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Common::Plugins::CachesConstructorArguments::Middleware,
              ConvenientService::Common::Plugins::CleansExceptionBacktrace::Middleware,
              ConvenientService::Service::Plugins::CanHaveSteps::Middleware,
              ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Middleware
            ]
          end

          it "sets service middlewares for `#initialize`" do
            expect(service_class.middlewares(:initialize).to_a).to eq(initialize_middlewares)
          end
        end

        example_group ".before middlewares" do
          let(:class_before_middlewares) do
            [
              ConvenientService::Service::Plugins::CanHaveBeforeStepCallbacks::Middleware
            ]
          end

          it "sets service middlewares for `.before`" do
            expect(service_class.middlewares(:before, scope: :class).to_a).to eq(class_before_middlewares)
          end
        end

        example_group ".around middlewares" do
          let(:class_around_middlewares) do
            [
              ConvenientService::Service::Plugins::CanHaveAroundStepCallbacks::Middleware
            ]
          end

          it "sets service middlewares for `.around`" do
            expect(service_class.middlewares(:around, scope: :class).to_a).to eq(class_around_middlewares)
          end
        end

        example_group ".after middlewares" do
          let(:class_after_middlewares) do
            [
              ConvenientService::Service::Plugins::CanHaveAfterStepCallbacks::Middleware
            ]
          end

          it "sets service middlewares for `.after`" do
            expect(service_class.middlewares(:after, scope: :class).to_a).to eq(class_after_middlewares)
          end
        end

        example_group "#result middlewares" do
          let(:result_middlewares) do
            [
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Service::Plugins::CountsStubbedResultsInvocations::Middleware,
              ConvenientService::Service::Plugins::CanHaveStubbedResults::Middleware,
              ConvenientService::Common::Plugins::CanHaveCallbacks::Middleware,
              ConvenientService::Service::Plugins::SetsParentToForeignResult::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Common::Plugins::CleansExceptionBacktrace::Middleware,
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware

              ##
              # TODO: Rewrite. This plugin does NOT do what it states. Probably I was NOT with a clear mind while writing it (facepalm).
              #
              # ConvenientService::Service::Plugins::RaisesOnDoubleResult::Middleware,
            ]
          end

          it "sets service middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a).to eq(result_middlewares)
          end
        end

        example_group "#regular_result middlewares" do
          let(:regular_result_middlewares) do
            [
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware
            ]
          end

          it "sets service middlewares for `#regular_result`" do
            expect(service_class.middlewares(:regular_result).to_a).to eq(regular_result_middlewares)
          end
        end

        example_group "#steps_result middlewares" do
          let(:steps_result_middlewares) do
            [
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware
            ]
          end

          it "sets service middlewares for `#steps_result`" do
            expect(service_class.middlewares(:steps_result).to_a).to eq(steps_result_middlewares)
          end
        end

        example_group "#fallback_failure_result middlewares" do
          let(:fallback_failure_result_middlewares) do
            [
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Common::Plugins::CleansExceptionBacktrace::Middleware,
              ConvenientService::Service::Plugins::CanHaveFallbacks::Middleware.with(status: :failure)
            ]
          end

          it "sets service middlewares for `#fallback_failure_result`" do
            expect(service_class.middlewares(:fallback_failure_result).to_a).to eq(fallback_failure_result_middlewares)
          end
        end

        example_group "#fallback_error_result middlewares" do
          let(:fallback_error_result_middlewares) do
            [
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Common::Plugins::CleansExceptionBacktrace::Middleware,
              ConvenientService::Service::Plugins::CanHaveFallbacks::Middleware.with(status: :error)
            ]
          end

          it "sets service middlewares for `#fallback_error_result`" do
            expect(service_class.middlewares(:fallback_error_result).to_a).to eq(fallback_error_result_middlewares)
          end
        end

        example_group "#fallback_result middlewares" do
          let(:fallback_result_middlewares) do
            [
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Common::Plugins::CleansExceptionBacktrace::Middleware,
              ConvenientService::Service::Plugins::CanHaveFallbacks::Middleware.with(status: nil)
            ]
          end

          it "sets service middlewares for `#fallback_result`" do
            expect(service_class.middlewares(:fallback_result).to_a).to eq(fallback_result_middlewares)
          end
        end

        example_group "#negated_result middlewares" do
          let(:negated_result_middlewares) do
            [
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Common::Plugins::EnsuresNegatedJSendResult::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Common::Plugins::CleansExceptionBacktrace::Middleware
            ]
          end

          it "sets service middlewares for `#negated_result`" do
            expect(service_class.middlewares(:negated_result).to_a).to eq(negated_result_middlewares)
          end
        end

        example_group "#success middlewares" do
          let(:success_middlewares) do
            [
              ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Middleware
            ]
          end

          it "sets service middlewares for `#success`" do
            expect(service_class.middlewares(:success).to_a).to eq(success_middlewares)
          end
        end

        example_group "#failure middlewares" do
          let(:failure_middlewares) do
            [
              ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Middleware
            ]
          end

          it "sets service middlewares for `#failure`" do
            expect(service_class.middlewares(:failure).to_a).to eq(failure_middlewares)
          end
        end

        example_group "#error middlewares" do
          let(:error_middlewares) do
            [
              ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Middleware
            ]
          end

          it "sets service middlewares for `#error`" do
            expect(service_class.middlewares(:error).to_a).to eq(error_middlewares)
          end
        end

        example_group ".result middlewares" do
          let(:class_result_middlewares) do
            [
              ConvenientService::Service::Plugins::CountsStubbedResultsInvocations::Middleware,
              ConvenientService::Service::Plugins::CanHaveStubbedResults::Middleware
            ]
          end

          it "sets service middlewares for `.result`" do
            expect(service_class.middlewares(:result, scope: :class).to_a).to eq(class_result_middlewares)
          end
        end

        example_group "service internals" do
          example_group "concerns" do
            let(:concerns) do
              [
                ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
              ]
            end

            it "sets service internals concerns" do
              expect(service_class::Internals.concerns.to_a).to eq(concerns)
            end
          end
        end

        example_group "service result" do
          example_group "concerns" do
            let(:concerns) do
              [
                ConvenientService::Common::Plugins::HasInternals::Concern,
                ConvenientService::Common::Plugins::HasConstructor::Concern,
                ConvenientService::Common::Plugins::HasConstructorWithoutInitialize::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveStep::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasNegatedResult::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromFallback::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasInspect::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeOwnResult::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveParentResult::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeStubbedResult::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStubbedResultInvocationsCounter::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Concern,
                ConvenientService::Common::Plugins::HasJSendResultDuckShortSyntax::Concern
              ]
            end

            it "sets service result concerns" do
              expect(service_class::Result.concerns.to_a).to eq(concerns)
            end
          end

          example_group "#initialize middlewares" do
            let(:initialize_middlewares) do
              [
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStubbedResultInvocationsCounter::Middleware, ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Middleware
              ]
            end

            it "sets service result middlewares for `#initialize`" do
              expect(service_class::Result.middlewares(:initialize).to_a).to eq(initialize_middlewares)
            end
          end

          example_group "#negated_result middlewares" do
            let(:negated_result_middlewares) do
              [
                ConvenientService::Common::Plugins::EnsuresNegatedJSendResult::Middleware
              ]
            end

            it "sets service result middlewares for `#negated_result`" do
              expect(service_class::Result.middlewares(:negated_result).to_a).to eq(negated_result_middlewares)
            end
          end

          example_group "#data middlewares" do
            let(:data_middlewares) do
              [
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#data`" do
              expect(service_class::Result.middlewares(:data).to_a).to eq(data_middlewares)
            end
          end

          example_group "#message middlewares" do
            let(:message_middlewares) do
              [
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#message`" do
              expect(service_class::Result.middlewares(:message).to_a).to eq(message_middlewares)
            end
          end

          example_group "#code middlewares" do
            let(:code_middlewares) do
              [
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#code`" do
              expect(service_class::Result.middlewares(:code).to_a).to eq(code_middlewares)
            end
          end

          example_group "service result data" do
            example_group "concerns" do
              let(:concerns) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern
                ]
              end

              it "sets service result data concerns" do
                expect(service_class::Result::Data.concerns.to_a).to eq(concerns)
              end
            end
          end

          example_group "service result message" do
            example_group "concerns" do
              let(:concerns) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern
                ]
              end

              it "sets service result message concerns" do
                expect(service_class::Result::Message.concerns.to_a).to eq(concerns)
              end
            end
          end

          example_group "service result code" do
            example_group "concerns" do
              let(:concerns) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasInspect::Concern
                ]
              end

              it "sets service result code concerns" do
                expect(service_class::Result::Code.concerns.to_a).to eq(concerns)
              end
            end
          end

          example_group "service result status" do
            example_group "concerns" do
              let(:concerns) do
                [
                  ConvenientService::Common::Plugins::HasInternals::Concern,
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern,
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Concern
                ]
              end

              it "sets service result status concerns" do
                expect(service_class::Result::Status.concerns.to_a).to eq(concerns)
              end
            end

            example_group "#success? middlewares" do
              let(:is_success_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#success?`" do
                expect(service_class::Result::Status.middlewares(:success?).to_a).to eq(is_success_middlewares)
              end
            end

            example_group "#failure? middlewares" do
              let(:is_failure_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#failure?`" do
                expect(service_class::Result::Status.middlewares(:failure?).to_a).to eq(is_failure_middlewares)
              end
            end

            example_group "#error? middlewares" do
              let(:is_error_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#error?`" do
                expect(service_class::Result::Status.middlewares(:error?).to_a).to eq(is_error_middlewares)
              end
            end

            example_group "#not_success? middlewares" do
              let(:is_not_success_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#not_success?`" do
                expect(service_class::Result::Status.middlewares(:not_success?).to_a).to eq(is_not_success_middlewares)
              end
            end

            example_group "#not_failure? middlewares" do
              let(:is_not_failure_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#not_failure?`" do
                expect(service_class::Result::Status.middlewares(:not_failure?).to_a).to eq(is_not_failure_middlewares)
              end
            end

            example_group "#not_error? middlewares" do
              let(:is_not_error_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#not_error?`" do
                expect(service_class::Result::Status.middlewares(:not_error?).to_a).to eq(is_not_error_middlewares)
              end
            end

            example_group "service result status internals" do
              example_group "concerns" do
                let(:concerns) do
                  [
                    ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                  ]
                end

                it "sets service result status internals concerns" do
                  expect(service_class::Result::Status::Internals.concerns.to_a).to eq(concerns)
                end
              end
            end
          end

          example_group "service result internals" do
            example_group "concerns" do
              let(:concerns) do
                [
                  ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                ]
              end

              it "sets service result internals concerns" do
                expect(service_class::Result::Internals.concerns.to_a).to eq(concerns)
              end
            end
          end
        end

        example_group "service step" do
          example_group "concerns" do
            let(:concerns) do
              [
                ConvenientService::Common::Plugins::HasInternals::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Concern,

                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeCompleted::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeServiceStep::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Concern,

                ConvenientService::Common::Plugins::CanHaveCallbacks::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern,

                ConvenientService::Common::Plugins::HasJSendResultDuckShortSyntax::Concern
              ]
            end

            it "sets service step concerns" do
              expect(service_class::Step.concerns.to_a).to eq(concerns)
            end
          end

          example_group "#result middlewares" do
            let(:result_middlewares) do
              [
                ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
                ConvenientService::Common::Plugins::CanHaveCallbacks::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveParentResult::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Middleware.with(fallback_true_status: :failure),
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::RaisesOnNotResultReturnValue::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeServiceStep::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Middleware
              ]
            end

            it "sets service step middlewares for `#result`" do
              expect(service_class::Step.middlewares(:result).to_a).to eq(result_middlewares)
            end
          end

          example_group "#service_result middlewares" do
            let(:service_result_middlewares) do
              [
                ConvenientService::Common::Plugins::CachesReturnValue::Middleware
              ]
            end

            it "sets service step middlewares for `#service_result`" do
              expect(service_class::Step.middlewares(:service_result).to_a).to eq(service_result_middlewares)
            end
          end

          example_group "#method_result middlewares" do
            let(:method_result_middlewares) do
              [
                ConvenientService::Common::Plugins::CachesReturnValue::Middleware
              ]
            end

            it "sets service step middlewares for `#method_result`" do
              expect(service_class::Step.middlewares(:method_result).to_a).to eq(method_result_middlewares)
            end
          end

          example_group "service step internals" do
            example_group "concerns" do
              let(:concerns) do
                [
                  ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                ]
              end

              it "sets service internals concerns" do
                expect(service_class::Step::Internals.concerns.to_a).to eq(concerns)
              end
            end
          end
        end
      end

      context "when `:rollbacks` option is passed" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(described_class) do |mod|
              include mod.with(:rollbacks)
            end
          end
        end

        example_group "#result middlewares" do
          it "adds `ConvenientService::Service::Plugins::CanHaveRollbacks::Middleware` after `ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware` to service step middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Common::CanHaveCallbacks::Middleware && current_middleware == ConvenientService::Service::Plugins::CanHaveRollbacks::Middleware }).not_to be_nil
          end
        end
      end

      context "when `:fault_tolerance` option is passed" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(described_class) do |mod|
              include mod.with(:fault_tolerance)
            end
          end
        end

        example_group "service" do
          example_group ".result middlewares" do
            it "adds `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware` after `ConvenientService::Service::Plugins::CanHaveStubbedResults::Middleware` to service middlewares for `.result`" do
              expect(service_class.middlewares(:result, scope: :class).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::CanHaveStubbedResults::Middleware && current_middleware == ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware }).not_to be_nil
            end
          end

          example_group "#result middlewares" do
            it "adds `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware` after `ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware` to service middlewares for `#result`" do
              expect(service_class.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware && current_middleware == ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware }).not_to be_nil
            end
          end

          example_group "#negated_result middlewares" do
            it "adds `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware` after `ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware` to service middlewares for `#result`" do
              expect(service_class.middlewares(:negated_result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware && current_middleware == ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware }).not_to be_nil
            end
          end

          example_group "service result" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromException::Concern` after `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromFallback::Concern` to service result concerns" do
                expect(service_class::Result.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromFallback::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromException::Concern }).not_to be_nil
              end
            end
          end
        end
      end
    end

    context "when included multiple times" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod

            include mod
          end
        end
      end

      ##
      # NOTE: Check the following discussion for details:
      # - https://github.com/marian13/convenient_service/discussions/43
      #
      it "applies its `included` block only once" do
        expect(service_class.middlewares(:result).to_a.size).to eq(9)
      end
    end
  end

  example_group "class methods" do
    describe ".default_options" do
      ##
      # NOTE: It tested by `test/lib/convenient_service/service/configs/standard_test.rb`.
      #
      # context "when `RSpec` is NOT loaded" do
      #   it "returns default options without `:rspec`" do
      #     # ...
      #   end
      # end
      ##

      context "when `RSpec` is loaded" do
        let(:default_options) do
          Set[
            :essential,
            :callbacks,
            :fallbacks,
            :inspect,
            :recalculation,
            :result_parents_trace,
            :code_review_automation,
            :short_syntax,
            :type_safety,
            :exception_services_trace,
            :per_instance_caching,
            :mermaid_flowchart,
            :backtrace_cleaner,
            :rspec
          ]
        end

        it "returns default options with `:rspec`" do
          expect(described_class.default_options).to eq(default_options)
        end
      end
    end

    describe ".service_class?" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      specify do
        expect { described_class.service_class?(service_class) }
          .to delegate_to(ConvenientService::Service::Configs::Standard::Commands::IsServiceClass, :call)
          .with_arguments(service_class: service_class)
          .and_return_its_value
      end
    end

    describe ".service?" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:service) { service_class.new }

      specify do
        expect { described_class.service?(service) }
          .to delegate_to(ConvenientService::Service::Configs::Standard::Commands::IsService, :call)
          .with_arguments(service: service)
          .and_return_its_value
      end
    end
  end
end

RSpec.describe ConvenientService::Service::Configs::Standard, type: :amazing_print do
  example_group "modules" do
    context "when included" do
      context "when `:amazing_print_inspect` option is passed" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(described_class) do |mod|
              include mod.with(:amazing_print_inspect)
            end
          end
        end

        example_group "service" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::HasAmazingPrintInspect::Concern` after `ConvenientService::Service::Plugins::HasInspect::Concern` to service concerns" do
              expect(service_class.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasAmazingPrintInspect::Concern }).not_to be_nil
            end
          end

          example_group "service result" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasAmazingPrintInspect::Concern` after `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasInspect::Concern` to service result concerns" do
                expect(service_class::Result.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasAmazingPrintInspect::Concern }).not_to be_nil
              end
            end

            example_group "service result data" do
              example_group "concerns" do
                it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasAmazingPrintInspect::Concern` after `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern` to service result data" do
                  expect(service_class::Result::Data.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasAmazingPrintInspect::Concern }).not_to be_nil
                end
              end
            end

            example_group "service result message" do
              example_group "concerns" do
                it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAmazingPrintInspect::Concern` after `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern` to service result message" do
                  expect(service_class::Result::Message.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAmazingPrintInspect::Concern }).not_to be_nil
                end
              end
            end

            example_group "service result code" do
              example_group "concerns" do
                it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasAmazingPrintInspect::Concern` after `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasInspect::Concern` to service result code" do
                  expect(service_class::Result::Code.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasAmazingPrintInspect::Concern }).not_to be_nil
                end
              end
            end

            example_group "service result status" do
              example_group "concerns" do
                it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasAmazingPrintInspect::Concern` from service concerns" do
                  expect(service_class::Result::Status.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasAmazingPrintInspect::Concern }).not_to be_nil
                end
              end
            end
          end

          example_group "service step" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAmazingPrintInspect::Concern` from service concerns" do
                expect(service_class::Step.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAmazingPrintInspect::Concern }).not_to be_nil
              end
            end
          end
        end
      end
    end
  end
end

RSpec.describe ConvenientService::Service::Configs::Standard, type: :awesome_print do
  example_group "modules" do
    context "when included" do
      context "when `:awesome_print_inspect` option is passed" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(described_class) do |mod|
              include mod.with(:awesome_print_inspect)
            end
          end
        end

        example_group "service" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::HasAwesomePrintInspect::Concern` after `ConvenientService::Service::Plugins::HasInspect::Concern` to service concerns" do
              expect(service_class.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasAwesomePrintInspect::Concern }).not_to be_nil
            end
          end

          example_group "service result" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasAwesomePrintInspect::Concern` after `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasInspect::Concern` to service result concerns" do
                expect(service_class::Result.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasAwesomePrintInspect::Concern }).not_to be_nil
              end
            end

            example_group "service result data" do
              example_group "concerns" do
                it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasAwesomePrintInspect::Concern` after `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern` to service result data" do
                  expect(service_class::Result::Data.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasAwesomePrintInspect::Concern }).not_to be_nil
                end
              end
            end

            example_group "service result message" do
              example_group "concerns" do
                it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAwesomePrintInspect::Concern` after `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern` to service result message" do
                  expect(service_class::Result::Message.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAwesomePrintInspect::Concern }).not_to be_nil
                end
              end
            end

            example_group "service result code" do
              example_group "concerns" do
                it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasAwesomePrintInspect::Concern` after `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasInspect::Concern` to service result code" do
                  expect(service_class::Result::Code.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasAwesomePrintInspect::Concern }).not_to be_nil
                end
              end
            end

            example_group "service result status" do
              example_group "concerns" do
                it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasAwesomePrintInspect::Concern` from service concerns" do
                  expect(service_class::Result::Status.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasAwesomePrintInspect::Concern }).not_to be_nil
                end
              end
            end
          end

          example_group "service step" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAwesomePrintInspect::Concern` from service concerns" do
                expect(service_class::Step.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern && current_middleware == ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAwesomePrintInspect::Concern }).not_to be_nil
              end
            end
          end
        end
      end
    end
  end
end

RSpec.describe ConvenientService::Service::Configs::Standard, type: :rails do
  example_group "modules" do
    context "when included" do
      context "when `:active_model_validations` option is passed" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(described_class) do |mod|
              include mod.with(:active_model_validations)
            end
          end
        end

        example_group "service" do
          example_group "concerns" do
            it "adds `ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern` after `ConvenientService::Plugins::Service::HasJSendResultStatusCheckShortSyntax::Concern` to service concerns" do
              expect(service_class.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::HasJSendResultStatusCheckShortSyntax::Concern && current_middleware == ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern }).not_to be_nil
            end
          end

          example_group "#result middlewares" do
            it "adds `ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Middleware` after `ConvenientService::Plugins::Common::CleansExceptionBacktrace::Middleware` to service middlewares for `#result`" do
              expect(service_class.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Common::CleansExceptionBacktrace::Middleware && current_middleware == ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Middleware }).not_to be_nil
            end
          end
        end
      end
    end
  end
end

RSpec.describe ConvenientService::Service::Configs::Standard, type: :dry do
  example_group "modules" do
    context "when included" do
      context "when `:dry_initializer` option is passed" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(described_class) do |mod|
              include mod.with(:dry_initializer)
            end
          end
        end

        example_group "service" do
          example_group "concerns" do
            it "adds `ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern` after `ConvenientService::Plugins::Service::HasJSendResultStatusCheckShortSyntax::Concern` to service concerns" do
              expect(service_class.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::HasJSendResultStatusCheckShortSyntax::Concern && current_middleware == ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern }).not_to be_nil
            end
          end
        end
      end
    end
  end
end

RSpec.describe ConvenientService::Service::Configs::Standard, type: :memo_wise do
  example_group "modules" do
    context "when included" do
      context "when `:memo_wise` option is passed" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(described_class) do |mod|
              include mod.with(:memo_wise)
            end
          end
        end

        example_group "service" do
          example_group "concerns" do
            it "adds `ConvenientService::Plugins::Common::HasMemoization::UsingMemoWise::Concern` after `ConvenientService::Plugins::Service::HasJSendResultStatusCheckShortSyntax::Concern` to service concerns" do
              expect(service_class.concerns.to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::HasJSendResultStatusCheckShortSyntax::Concern && current_middleware == ConvenientService::Plugins::Common::HasMemoization::UsingMemoWise::Concern }).not_to be_nil
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/MultipleDescribes
