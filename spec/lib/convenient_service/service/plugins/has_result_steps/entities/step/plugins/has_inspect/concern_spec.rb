# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Plugins::HasInspect::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:step_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Concern

        include mod

        def self.name
          "Step"
        end
      end
    end
  end

  let(:step_instance) { step_class.new(service, container: container) }

  let(:service) { step_service_klass }

  let(:step_service_klass) do
    Class.new do
      def self.name
        "Service"
      end
    end
  end

  let(:organizer_service_klass) do
    Class.new do
      def self.name
        "Organizer"
      end
    end
  end

  let(:container) { organizer_service_klass }

  let(:args) { [service] }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { step_class }

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    describe "#inspect" do
      it "returns `inspect` representation of step" do
        expect(step_instance.inspect).to eq("<#{step_instance.container.klass.name}::Step service: #{step_instance.service.klass.name}>")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
