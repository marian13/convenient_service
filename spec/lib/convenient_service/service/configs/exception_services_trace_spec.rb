# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::ExceptionServicesTrace, type: :standard do
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
        example_group "#initialize middlewares" do
          it "prepends `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#initialize`" do
            expect(service_class.middlewares(:initialize).to_a.first).to eq(ConvenientService::Service::Plugins::CollectsServicesInException::Middleware)
          end
        end

        example_group "#result middlewares" do
          it "prepends `ConvenientService::Service::Plugins::CollectsServicesInException::Middleware` to service middlewares for `#result`" do
            expect(service_class.middlewares(:result).to_a.first).to eq(ConvenientService::Plugins::Service::CollectsServicesInException::Middleware)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
