# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasAwesomePrintInspect::Concern do
  let(:service) do
    Class.new do
      include ConvenientService::Configs::Standard

      include ConvenientService::Configs::AwesomePrintInspect

      def result
        success
      end

      def self.name
        "ImportantService"
      end
    end
  end

  let(:result) { service.result }

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
    describe "#inspect" do
      let(:keywords) { ["ConvenientService", "entity", "Result", "status", "success", "service", "ImportantService"] }

      it "returns `inspect` representation of result" do
        expect(result.inspect).to include(*keywords)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
