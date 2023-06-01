# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Rails::Gemfile::RailsService::Config do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    specify { expect(described_class).to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Configs::Standard) }

      example_group "service" do
        example_group "concerns" do
          let(:concerns) do
            [
              ConvenientService::Service::Plugins::CanHaveStubbedResult::Concern,
              ConvenientService::Common::Plugins::HasInternals::Concern,
              ConvenientService::Service::Plugins::HasInspect::Concern,
              ConvenientService::Common::Plugins::HasConstructor::Concern,
              ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern,
              ConvenientService::Service::Plugins::HasResult::Concern,
              ConvenientService::Service::Plugins::CanHaveSteps::Concern,
              ConvenientService::Common::Plugins::CachesConstructorParams::Concern,
              ConvenientService::Common::Plugins::CanBeCopied::Concern,
              ConvenientService::Service::Plugins::CanRecalculateResult::Concern,
              ConvenientService::Service::Plugins::HasResultShortSyntax::Concern,
              ConvenientService::Service::Plugins::HasResultStatusCheckShortSyntax::Concern,
              ConvenientService::Common::Plugins::HasCallbacks::Concern,
              ConvenientService::Common::Plugins::HasAroundCallbacks::Concern,
              ConvenientService::Service::Plugins::CanHaveTryResult::Concern,
              ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern,
              ConvenientService::Common::Plugins::HasAttributes::UsingActiveModelAttributes::Concern,
              ConvenientService::Service::Plugins::HasResultParamsValidations::UsingActiveModelValidations::Concern
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
              ConvenientService::Common::Plugins::CachesConstructorParams::Middleware,
              ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware
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
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Common::Plugins::HasCallbacks::Middleware,
              ConvenientService::Common::Plugins::HasAroundCallbacks::Middleware,
              ConvenientService::Service::Plugins::HasResultParamsValidations::UsingActiveModelValidations::Middleware,
              ConvenientService::Service::Plugins::HasResult::Middleware,
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

        example_group "#try_result middlewares" do
          let(:try_result_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::CanHaveTryResult::Middleware
            ]
          end

          it "sets service middlewares for `#try_result`" do
            expect(service_class.middlewares(:try_result).to_a).to eq(try_result_middlewares)
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
              ConvenientService::Service::Plugins::HasResultShortSyntax::Success::Middleware
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
              ConvenientService::Service::Plugins::HasResultShortSyntax::Failure::Middleware
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
              ConvenientService::Service::Plugins::HasResultShortSyntax::Error::Middleware
            ]
          end

          it "sets service middlewares for `#error`" do
            expect(service_class.middlewares(:error).to_a).to eq(error_middlewares)
          end
        end

        example_group ".step middlewares" do
          let(:step_class_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::CanHaveMethodSteps::Middleware,
              ConvenientService::Service::Plugins::CanHaveResultStep::Middleware
            ]
          end

          it "sets service middlewares for `.step`" do
            expect(service_class.middlewares(:step, scope: :class).to_a).to eq(step_class_middlewares)
          end
        end

        example_group ".result middlewares" do
          let(:class_result_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::CanHaveStubbedResult::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasInspect::Concern,
                ConvenientService::Common::Plugins::HasConstructor::Concern,
                ConvenientService::Common::Plugins::HasConstructorWithoutInitialize::Concern,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Concern,
                ConvenientService::Common::Plugins::HasResultDuckShortSyntax::Concern,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::CanRecalculateResult::Concern,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasStep::Concern,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::CanHaveParentResult::Concern
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Middleware,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasStep::Initialize::Middleware,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::CanHaveParentResult::Initialize::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::MarksResultStatusAsChecked::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::MarksResultStatusAsChecked::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::MarksResultStatusAsChecked::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::MarksResultStatusAsChecked::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::MarksResultStatusAsChecked::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::MarksResultStatusAsChecked::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#code`" do
              expect(service_class::Result.middlewares(:code).to_a).to eq(code_middlewares)
            end
          end

          example_group "#to_kwargs middlewares" do
            let(:to_kwargs_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasStep::ToKwargs::Middleware,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::CanHaveParentResult::ToKwargs::Middleware
              ]
            end

            it "sets service result middlewares for `#to_kwargs`" do
              expect(service_class::Result.middlewares(:to_kwargs).to_a).to eq(to_kwargs_middlewares)
            end
          end

          example_group "service result data" do
            example_group "concerns" do
              let(:concerns) do
                [
                  ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern
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
                  ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern
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
                  ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasInspect::Concern
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
                  ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern
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
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeCompleted::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern,
                ConvenientService::Common::Plugins::HasResultDuckShortSyntax::Concern,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeTried::Concern
              ]
            end

            it "sets service step concerns" do
              expect(service_class::Step.concerns.to_a).to eq(concerns)
            end
          end

          example_group "#initialize middlewares" do
            let(:initialize_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeTried::Initialize::Middleware
              ]
            end

            it "sets service step middlewares for `#initialize`" do
              expect(service_class::Step.middlewares(:initialize).to_a).to eq(initialize_middlewares)
            end
          end

          example_group "#original_result middlewares" do
            let(:original_result_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Common::Plugins::CachesReturnValue::Middleware
              ]
            end

            it "sets service step middlewares for `#original_result`" do
              expect(service_class::Step.middlewares(:original_result).to_a).to eq(original_result_middlewares)
            end
          end

          example_group "#result middlewares" do
            let(:result_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeTried::Result::Middleware,
                ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveParentResult::Middleware
              ]
            end

            it "sets service step middlewares for `#result`" do
              expect(service_class::Step.middlewares(:result).to_a).to eq(result_middlewares)
            end
          end

          example_group "#original_try_result middlewares" do
            let(:original_try_result_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Common::Plugins::CachesReturnValue::Middleware
              ]
            end

            it "sets service middlewares for `#original_try_result`" do
              expect(service_class::Step.middlewares(:original_try_result).to_a).to eq(original_try_result_middlewares)
            end
          end

          example_group "#try_result middlewares" do
            let(:try_result_middlewares) do
              [
                ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
                ConvenientService::Common::Plugins::CachesReturnValue::Middleware
              ]
            end

            it "sets service middlewares for `#try_result`" do
              expect(service_class::Step.middlewares(:try_result).to_a).to eq(try_result_middlewares)
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
        expect(service_class.middlewares(:result).to_a.size).to eq(7)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
