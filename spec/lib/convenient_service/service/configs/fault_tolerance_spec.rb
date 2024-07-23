# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::FaultTolerance, type: :standard do
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
        example_group ".result middlewares" do
          it "adds `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware` to service middlewares for `.result`" do
            expect(service_class.middlewares(:result, scope: :class).to_a.last).to eq(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware)
          end
        end

        example_group "#regular_result middlewares" do
          it "adds `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware` to service middlewares for `#regular_result`" do
            expect(service_class.middlewares(:regular_result).to_a.last).to eq(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware)
          end
        end

        example_group "#steps_result middlewares" do
          it "adds `ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware` to service middlewares for `#steps_result`" do
            expect(service_class.middlewares(:steps_result).to_a.last).to eq(ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Middleware)
          end
        end

        example_group "service result" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromException::Concern` to service result concerns" do
              expect(service_class.result_class.concerns.to_a).to include(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromException::Concern)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
