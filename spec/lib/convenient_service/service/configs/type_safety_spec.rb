# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::TypeSafety, type: :standard do
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

      specify { expect(service_class).to include_module(ConvenientService::Service::Configs::Essential) }

      example_group "service" do
        example_group "#result middlewares" do
          it "adds `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware` before `ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware` to service middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware && current_middleware == ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware }).not_to be_nil
          end
        end

        example_group "service step" do
          example_group "#result middlewares" do
            it "adds `ConvenientService::Plugins::Step::RaisesOnNotResultReturnValue::Middleware` before `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeServiceStep::Middleware` to service step middlewares for `#result`" do
              expect(service_class::Step.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Step::RaisesOnNotResultReturnValue::Middleware && current_middleware == ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeServiceStep::Middleware }).not_to be_nil
            end
          end
        end

        context "when service class does NOT include `Fallbacks` config" do
          example_group "#fallback_failure_result middlewares" do
            it "does NOT add `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware`" do
              expect(service_class.middlewares(:fallback_failure_result).to_a).not_to include(ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware)
            end
          end

          example_group "#fallback_error_result middlewares" do
            it "does NOT add `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware`" do
              expect(service_class.middlewares(:fallback_error_result).to_a).not_to include(ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware)
            end
          end

          example_group "#fallback_result middlewares" do
            it "does NOT add `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware`" do
              expect(service_class.middlewares(:fallback_result).to_a).not_to include(ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware)
            end
          end
        end

        context "when service class includes `Fallbacks` config" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(described_class) do |mod|
                include ConvenientService::Service::Configs::Fallbacks

                include mod
              end
            end
          end

          example_group "#fallback_failure_result middlewares" do
            it "adds `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware` before `ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :failure)` to service middlewares for `#fallback_failure_result`" do
              expect(service_class.middlewares(:fallback_failure_result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware && current_middleware == ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :failure) }).not_to be_nil
            end
          end

          example_group "#fallback_error_result middlewares" do
            it "adds `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware` before `ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :error)` to service middlewares for `#fallback_error_result`" do
              expect(service_class.middlewares(:fallback_error_result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware && current_middleware == ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: :error) }).not_to be_nil
            end
          end

          example_group "#fallback_result middlewares" do
            it "adds `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware` before `ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: nil)` to service middlewares for `#fallback_result`" do
              expect(service_class.middlewares(:fallback_result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware && current_middleware == ConvenientService::Plugins::Service::CanHaveFallbacks::Middleware.with(status: nil) }).not_to be_nil
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
