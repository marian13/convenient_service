# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::Standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Service::Configs::Minimal) }

      example_group "service" do
        example_group "concerns" do
          let(:concerns) do
            [
              ConvenientService::Service::Plugins::CanHaveStubbedResults::Concern,
              ConvenientService::Common::Plugins::HasInternals::Concern,
              ConvenientService::Service::Plugins::HasInspect::Concern,
              ConvenientService::Common::Plugins::HasConstructor::Concern,
              ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern,
              ConvenientService::Service::Plugins::HasResult::Concern,
              ConvenientService::Service::Plugins::HasJSendResult::Concern,
              ConvenientService::Service::Plugins::CanHaveSteps::Concern,
              ConvenientService::Common::Plugins::CachesConstructorArguments::Concern,
              ConvenientService::Common::Plugins::CanBeCopied::Concern,
              ConvenientService::Service::Plugins::CanRecalculateResult::Concern,
              ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Concern,
              ConvenientService::Service::Plugins::HasJSendResultStatusCheckShortSyntax::Concern,
              ConvenientService::Common::Plugins::HasCallbacks::Concern,
              ConvenientService::Common::Plugins::HasAroundCallbacks::Concern,
              ConvenientService::Service::Plugins::HasNegatedResult::Concern,
              ConvenientService::Service::Plugins::HasNegatedJSendResult::Concern,
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Concern,
              ConvenientService::Service::Plugins::CanHaveFallbacks::Concern,
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
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Common::Plugins::CachesConstructorArguments::Middleware
            ]
          end

          it "sets service middlewares for `#initialize`" do
            expect(service_class.middlewares(:initialize).to_a).to eq(initialize_middlewares)
          end
        end

        example_group "#result middlewares" do
          let(:result_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::CountsStubbedResultsInvocations::Middleware,
              ConvenientService::Service::Plugins::CanHaveStubbedResults::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Common::Plugins::HasCallbacks::Middleware,
              ConvenientService::Common::Plugins::HasAroundCallbacks::Middleware,
              ConvenientService::Service::Plugins::SetsParentToForeignResult::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Service::Plugins::CanHaveSteps::Middleware

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

        example_group "#fallback_failure_result middlewares" do
          let(:fallback_failure_result_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
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
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Service::Plugins::CanHaveFallbacks::Middleware.with(status: :error)
            ]
          end

          it "sets service middlewares for `#fallback_error_result`" do
            expect(service_class.middlewares(:fallback_error_result).to_a).to eq(fallback_error_result_middlewares)
          end
        end

        example_group "#negated_result middlewares" do
          let(:negated_result_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::HasNegatedJSendResult::Middleware
            ]
          end

          it "sets service middlewares for `#negated_result`" do
            expect(service_class.middlewares(:negated_result).to_a).to eq(negated_result_middlewares)
          end
        end

        example_group "#step middlewares" do
          let(:step_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Common::Plugins::HasCallbacks::Middleware,
              ConvenientService::Common::Plugins::HasAroundCallbacks::Middleware
            ]
          end

          it "sets service middlewares for `#step`" do
            expect(service_class.middlewares(:step).to_a).to eq(step_middlewares)
          end
        end

        example_group "#success middlewares" do
          let(:success_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
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
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
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
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Middleware
            ]
          end

          it "sets service middlewares for `#error`" do
            expect(service_class.middlewares(:error).to_a).to eq(error_middlewares)
          end
        end

        example_group ".step middlewares" do
          let(:class_step_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::CanHaveMethodSteps::Middleware
            ]
          end

          it "sets service middlewares for `.step`" do
            expect(service_class.middlewares(:step, scope: :class).to_a).to eq(class_step_middlewares)
          end
        end

        example_group ".result middlewares" do
          let(:class_result_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::CountsStubbedResultsInvocations::Middleware, ConvenientService::Service::Plugins::CanHaveStubbedResults::Middleware
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
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasInspect::Concern,
                ConvenientService::Common::Plugins::HasConstructor::Concern,
                ConvenientService::Common::Plugins::HasConstructorWithoutInitialize::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveStep::Concern,
                ConvenientService::Common::Plugins::HasJSendResultDuckShortSyntax::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanRecalculateResult::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeNegated::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeOwnResult::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveParentResult::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeStubbedResult::Concern,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStubbedResultInvocationsCounter::Concern
              ]
            end

            it "sets service result concerns" do
              expect(service_class::Result.concerns.to_a).to eq(concerns)
            end
          end

          example_group "#initialize middlewares" do
            let(:initialize_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStubbedResultInvocationsCounter::Middleware, ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Middleware
              ]
            end

            it "sets service result middlewares for `#initialize`" do
              expect(service_class::Result.middlewares(:initialize).to_a).to eq(initialize_middlewares)
            end
          end

          example_group "#success? middlewares" do
            let(:is_success_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#success?`" do
              expect(service_class::Result.middlewares(:success?).to_a).to eq(is_success_middlewares)
            end
          end

          example_group "#failure? middlewares" do
            let(:is_failure_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#failure?`" do
              expect(service_class::Result.middlewares(:failure?).to_a).to eq(is_failure_middlewares)
            end
          end

          example_group "#error? middlewares" do
            let(:is_error_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#error?`" do
              expect(service_class::Result.middlewares(:error?).to_a).to eq(is_error_middlewares)
            end
          end

          example_group "#not_success? middlewares" do
            let(:is_not_success_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#not_success?`" do
              expect(service_class::Result.middlewares(:not_success?).to_a).to eq(is_not_success_middlewares)
            end
          end

          example_group "#not_failure? middlewares" do
            let(:is_not_failure_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#not_failure?`" do
              expect(service_class::Result.middlewares(:not_failure?).to_a).to eq(is_not_failure_middlewares)
            end
          end

          example_group "#not_error? middlewares" do
            let(:is_not_error_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#not_error?`" do
              expect(service_class::Result.middlewares(:not_error?).to_a).to eq(is_not_error_middlewares)
            end
          end

          example_group "#data middlewares" do
            let(:data_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
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
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
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
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
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
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern
                ]
              end

              it "sets service result status concerns" do
                expect(service_class::Result::Status.concerns.to_a).to eq(concerns)
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
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeResultStep::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern,
                ConvenientService::Common::Plugins::HasJSendResultDuckShortSyntax::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Concern
              ]
            end

            it "sets service step concerns" do
              expect(service_class::Step.concerns.to_a).to eq(concerns)
            end
          end

          example_group "#result middlewares" do
            let(:result_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveParentResult::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::RaisesOnNotResultReturnValue::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeResultStep::CanBeExecuted::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::CanBeExecuted::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Middleware.with(fallback_true_status: :failure),
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveNegatedSteps::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveAlternativeSteps::Middleware
              ]
            end

            it "sets service step middlewares for `#result`" do
              expect(service_class::Step.middlewares(:result).to_a).to eq(result_middlewares)
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
      # https://github.com/marian13/convenient_service/discussions/43
      #
      it "applies its `included` block only once" do
        expect(service_class.middlewares(:result).to_a.size).to eq(10)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
