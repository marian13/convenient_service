# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::Callbacks, type: :standard do
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
        example_group "concerns" do
          it "adds `ConvenientService::Common::Plugins::CanHaveCallbacks::Concern` to service concerns" do
            expect(service_class.concerns.to_a.last).to eq(ConvenientService::Common::Plugins::CanHaveCallbacks::Concern)
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
          it "adds `ConvenientService::Common::Plugins::CanHaveCallbacks::Middleware` after `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Common::Plugins::CachesReturnValue::Middleware && current_middleware == ConvenientService::Common::Plugins::CanHaveCallbacks::Middleware }).not_to be_nil
          end
        end

        example_group "service step" do
          example_group "concerns" do
            it "adds `ConvenientService::Common::Plugins::CanHaveCallbacks::Concern` to service step concerns" do
              expect(service_class::Step.concerns.to_a.last).to eq(ConvenientService::Common::Plugins::CanHaveCallbacks::Concern)
            end
          end

          example_group "#result middlewares" do
            it "adds `ConvenientService::Common::Plugins::CanHaveCallbacks::Middleware` after `ConvenientService::Common::Plugins::CachesReturnValue::Middleware` to service step middlewares for `#result`" do
              expect(service_class::Step.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Common::Plugins::CachesReturnValue::Middleware && current_middleware == ConvenientService::Common::Plugins::CanHaveCallbacks::Middleware }).not_to be_nil
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
