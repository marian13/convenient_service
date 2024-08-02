# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::Fallbacks, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Config) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include ConvenientService::Service::Configs::Essential

            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Core) }

      example_group "service" do
        example_group "concerns" do
          it "adds `ConvenientService::Service::Plugins::CanHaveFallbacks::Concern` to service concerns" do
            expect(service_class.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::CanHaveFallbacks::Concern)
          end
        end

        example_group "#fallback_failure_result middlewares" do
          let(:fallback_failure_result_middlewares) do
            [
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

        example_group "#fallback_result middlewares" do
          let(:fallback_result_middlewares) do
            [
              ConvenientService::Service::Plugins::CollectsServicesInException::Middleware,
              ConvenientService::Common::Plugins::CachesReturnValue::Middleware,
              ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware,
              ConvenientService::Service::Plugins::CanHaveFallbacks::Middleware.with(status: nil)
            ]
          end

          it "sets service middlewares for `#fallback_result`" do
            expect(service_class.middlewares(:fallback_result).to_a).to eq(fallback_result_middlewares)
          end
        end

        example_group "service result" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Concern` to service result concerns" do
              expect(service_class::Result.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveFallbacks::Concern)
            end
          end
        end

        example_group "service step" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Concern` to service step concerns" do
              expect(service_class::Step.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Concern)
            end
          end

          example_group "#result middlewares" do
            it "adds `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Middleware.with(fallback_true_status: :failure)` after `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Middleware` to service step middlewares for `#result`" do
              expect(service_class::Step.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Middleware || current_middleware == ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Middleware.with(fallback_true_status: :failure) }).not_to be_nil
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
