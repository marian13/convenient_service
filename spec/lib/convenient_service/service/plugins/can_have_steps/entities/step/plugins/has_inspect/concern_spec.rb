# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern do
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
      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(service) do |service|
            include ConvenientService::Configs::Minimal

            step service

            def self.name
              "ContainerService"
            end
          end
        end
      end

      let(:service) do
        Class.new do
          include ConvenientService::Configs::Minimal

          def self.name
            "StepService"
          end
        end
      end

      let(:step) { container.steps.first }

      it "returns `inspect` representation of step" do
        expect(step_instance.inspect).to eq("<#{step.container.klass.name}::Step service: #{step.service.klass.name}>")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
