# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Configs::Standard do
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

      specify { expect(service_class).to include_module(ConvenientService::Core) }

      example_group "service" do
        example_group "concerns" do
          let(:concerns) do
            [
              ConvenientService::Service::Plugins::CanHaveStubbedResult::Concern,
              ConvenientService::Common::Plugins::HasInternals::Concern,
              ConvenientService::Common::Plugins::HasConstructor::Concern,
              ConvenientService::Plugins::Common::HasConstructorWithoutInitialize::Concern,
              ConvenientService::Common::Plugins::CachesConstructorParams::Concern,
              ConvenientService::Common::Plugins::CanBeCopied::Concern,
              ConvenientService::Service::Plugins::HasResult::Concern,
              ConvenientService::Service::Plugins::HasResultShortSyntax::Concern,
              ConvenientService::Service::Plugins::HasResultSteps::Concern,
              ConvenientService::Service::Plugins::CanRecalculateResult::Concern,
              ConvenientService::Service::Plugins::HasResultStatusCheckShortSyntax::Concern,
              ConvenientService::Common::Plugins::HasCallbacks::Concern,
              ConvenientService::Common::Plugins::HasAroundCallbacks::Concern,
              ConvenientService::Service::Plugins::HasInspect::Concern
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
              ConvenientService::Common::Plugins::CachesConstructorParams::Middleware
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
              ConvenientService::Service::Plugins::HasResult::Middleware,
              ConvenientService::Service::Plugins::HasResultSteps::Middleware,
              ConvenientService::Common::Plugins::HasCallbacks::Middleware,
              ConvenientService::Common::Plugins::HasAroundCallbacks::Middleware,
              ConvenientService::Service::Plugins::RaisesOnDoubleResult::Middleware,
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware
            ]
          end

          it "sets service middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a).to eq(result_middlewares)
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
          let(:class_step_middlewares) do
            [
              ConvenientService::Common::Plugins::NormalizesEnv::Middleware,
              ConvenientService::Service::Plugins::HasResultMethodSteps::Middleware
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
                ConvenientService::Common::Plugins::HasConstructor::Concern,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasResultShortSyntax::Concern,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::CanRecalculateResult::Concern,
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasInspect::Concern
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
                ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
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

          example_group "service result internals" do
            example_group "concerns" do
              let(:concerns) do
                [
                  ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
                ]
              end

              it "sets service result internals concerns" do
                expect(service_class::Internals.concerns.to_a).to eq(concerns)
              end
            end
          end
        end

        example_group "service step" do
          example_group "concerns" do
            let(:concerns) do
              [
                ConvenientService::Common::Plugins::HasInternals::Concern,
                ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Plugins::HasInspect::Concern
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
                ConvenientService::Common::Plugins::CachesReturnValue::Middleware
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
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
