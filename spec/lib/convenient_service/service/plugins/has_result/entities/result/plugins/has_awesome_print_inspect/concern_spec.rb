# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasAwesomePrintInspect::Concern do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#inspect" do
      let(:service) do
        Class.new do
          include ConvenientService::Configs::Minimal

          include ConvenientService::Configs::AwesomePrintInspect

          def self.name
            "ImportantService"
          end

          def result
            success
          end
        end
      end

      let(:result) { service.result }

      let(:keywords) { ["ConvenientService", "entity", "Result", "service", "ImportantService", "status", ":success"] }

      it "returns `inspect` representation of result" do
        expect(result.inspect).to include(*keywords)
      end

      specify do
        allow(result.service).to receive(:inspect_values).and_return({})

        expect { result.inspect }
          .to delegate_to(result.service.inspect_values, :[])
          .with_arguments(:name)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
