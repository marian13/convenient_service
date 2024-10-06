# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern, type: :standard do
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
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config

          def self.name
            "StepService"
          end
        end
      end

      let(:step) { container.new.steps.first }

      context "when step is neither service nor method step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(service) do |service|
              include ConvenientService::Standard::Config

              step "abc"

              def self.name
                "ContainerService"
              end
            end
          end
        end

        it "returns `inspect` representation of step without additional info" do
          expect(step.inspect).to eq("<ContainerService::Step>")
        end
      end

      context "when step is service step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(service) do |service|
              include ConvenientService::Standard::Config

              step service

              def self.name
                "ContainerService"
              end
            end
          end
        end

        it "returns `inspect` representation of step with service class" do
          expect(step.inspect).to eq("<ContainerService::Step service: StepService>")
        end

        context "when that service class is anonymous" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config
            end
          end

          it "uses custom class name" do
            expect(step.inspect).to eq("<ContainerService::Step service: AnonymousClass(##{service.object_id})>")
          end
        end
      end

      context "when step is method step" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :result

            def result
              success
            end

            def self.name
              "ContainerService"
            end
          end
        end

        it "returns `inspect` representation of step with method" do
          expect(step.inspect).to eq("<ContainerService::Step method: :result>")
        end
      end

      context "when container class is anonymous" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(service) do |service|
              include ConvenientService::Standard::Config

              step "abc"
            end
          end
        end

        it "uses custom class name" do
          expect(step.inspect).to eq("<AnonymousClass(##{container.object_id})::Step>")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
