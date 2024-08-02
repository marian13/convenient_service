# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::Recalculation, type: :standard do
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
          it "adds `ConvenientService::Common::Plugins::CachesConstructorArguments::Concern` from service concerns" do
            expect(service_class.concerns.to_a[-3]).to eq(ConvenientService::Common::Plugins::CachesConstructorArguments::Concern)
          end

          it "adds `ConvenientService::Common::Plugins::CanBeCopied::Concern` from service concerns" do
            expect(service_class.concerns.to_a[-2]).to eq(ConvenientService::Common::Plugins::CanBeCopied::Concern)
          end

          it "adds `ConvenientService::Service::Plugins::CanRecalculateResult::Concern` from service concerns" do
            expect(service_class.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::CanRecalculateResult::Concern)
          end
        end

        example_group "#initialize middlewares" do
          it "adds `ConvenientService::Common::Plugins::CachesConstructorArguments::Middleware` to service middlewares for `#initialize`" do
            expect(service_class.middlewares(:initialize).to_a.last).to eq(ConvenientService::Common::Plugins::CachesConstructorArguments::Middleware)
          end
        end

        example_group "service result" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanRecalculateResult::Concern` to service result concerns" do
              expect(service_class::Result.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanRecalculateResult::Concern)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
