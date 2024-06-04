# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::CodeReviewAutomation, type: :standard do
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

      specify { expect(service_class).to include_module(ConvenientService::Service::Configs::Essential) }

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
              ConvenientService::Service::Plugins::HasNegatedResult::Concern,
              ConvenientService::Service::Plugins::HasNegatedJSendResult::Concern,
              ConvenientService::Service::Plugins::CanHaveSteps::Concern,
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Concern,
              ConvenientService::Service::Plugins::CanHaveFallbacks::Concern,
              ConvenientService::Common::Plugins::CachesConstructorArguments::Concern,
              ConvenientService::Common::Plugins::CanBeCopied::Concern,
              ConvenientService::Service::Plugins::CanRecalculateResult::Concern,
              ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Concern,
              ConvenientService::Service::Plugins::HasJSendResultStatusCheckShortSyntax::Concern,
              ConvenientService::Common::Plugins::HasCallbacks::Concern,
              ConvenientService::Common::Plugins::HasAroundCallbacks::Concern,
              ConvenientService::Service::Plugins::HasMermaidFlowchart::Concern,
              ConvenientService::Service::Plugins::CountsResultResolutionsInvocations::Concern
            ]
          end

          it "sets service concerns" do
            expect(service_class.concerns.to_a).to eq(concerns)
          end
        end

        example_group "#result middlewares" do
          let(:result_middlewares) do
            [
              ConvenientService::Service::Plugins::RaisesOnDoubleResult::Middleware,
              ConvenientService::Service::Plugins::CountsStubbedResultsInvocations::Middleware,
              ConvenientService::Service::Plugins::CanHaveStubbedResults::Middleware,
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Common::Plugins::HasCallbacks::Middleware,
              ConvenientService::Common::Plugins::HasAroundCallbacks::Middleware,
              ConvenientService::Service::Plugins::SetsParentToForeignResult::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware
            ]
          end

          it "sets service middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a).to eq(result_middlewares)
          end
        end

        example_group "#success middlewares" do
          let(:success_middlewares) do
            [
              ConvenientService::Service::Plugins::CountsResultResolutionsInvocations::Middleware,
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
              ConvenientService::Service::Plugins::CountsResultResolutionsInvocations::Middleware,
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
              ConvenientService::Service::Plugins::CountsResultResolutionsInvocations::Middleware,
              ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Middleware
            ]
          end

          it "sets service middlewares for `#error`" do
            expect(service_class.middlewares(:error).to_a).to eq(error_middlewares)
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
