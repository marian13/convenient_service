# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAwesomePrintInspect::Concern do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { step_class }

      let(:step_class) do
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
      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(service) do |service|
            include ConvenientService::Configs::Minimal
            include ConvenientService::Configs::AwesomePrintInspect

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

      let(:step) { container.new.steps.first }

      let(:keywords) { ["ConvenientService", "entity", "Step", "container", "ContainerService", "service", "StepService"] }

      it "returns `inspect` representation of step" do
        expect(step.inspect).to include(*keywords)
      end

      context "when step is method step" do
        let(:container) do
          Class.new do
            include ConvenientService::Configs::Minimal
            include ConvenientService::Configs::AwesomePrintInspect

            step :result

            def result
              success
            end

            def self.name
              "ContainerService"
            end
          end
        end

        let(:keywords) { ["ConvenientService", "entity", "Step", "container", "ContainerService", "method", ":result"] }

        it "returns `inspect` representation of step" do
          expect(step.inspect).to include(*keywords)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
