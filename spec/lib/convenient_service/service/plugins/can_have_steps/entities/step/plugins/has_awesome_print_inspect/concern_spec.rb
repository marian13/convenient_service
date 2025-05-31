# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasAwesomePrintInspect

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAwesomePrintInspect::Concern, type: :awesome_print do
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
      let(:step) { container.new.steps.first }

      context "when step is neither service nor method step" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config.with(:awesome_print_inspect)

            step "abc"

            def self.name
              "ContainerService"
            end
          end
        end

        let(:keywords) { ["ConvenientService", ":entity", "Step", ":container", "ContainerService"] }

        it "returns `inspect` representation of step without additional info" do
          expect(step.inspect).to include(*keywords)
        end
      end

      context "when step is service step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(service) do |service|
              include ConvenientService::Standard::Config.with(:awesome_print_inspect)

              step service

              def self.name
                "ContainerService"
              end
            end
          end
        end

        let(:service) do
          Class.new do
            include ConvenientService::Standard::Config

            def self.name
              "StepService"
            end
          end
        end

        let(:keywords) { ["ConvenientService", ":entity", "Step", ":container", "ContainerService", ":service", "StepService"] }

        it "returns `inspect` representation of step with service class" do
          expect(step.inspect).to include(*keywords)
        end

        context "when that service class is anonymous" do
          let(:service) do
            Class.new do
              include ConvenientService::Standard::Config
            end
          end

          let(:keywords) { ["ConvenientService", ":entity", "Step", ":container", "ContainerService", ":service", "AnonymousClass(##{service.object_id})"] }

          it "uses custom class name" do
            expect(step.inspect).to include(*keywords)
          end
        end
      end

      context "when step is method step" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config.with(:awesome_print_inspect)

            step :result

            def result
              success
            end

            def self.name
              "ContainerService"
            end
          end
        end

        let(:keywords) { ["ConvenientService", ":entity", "Step", ":container", "ContainerService", ":method", ":result"] }

        it "returns `inspect` representation of step with method" do
          expect(step.inspect).to include(*keywords)
        end
      end

      context "when container class is anonymous" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config.with(:awesome_print_inspect)

            step "abc"
          end
        end

        let(:keywords) { ["ConvenientService", ":entity", "Step", ":container", "AnonymousClass(##{container.object_id})"] }

        it "uses custom class name" do
          expect(step.inspect).to include(*keywords)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
