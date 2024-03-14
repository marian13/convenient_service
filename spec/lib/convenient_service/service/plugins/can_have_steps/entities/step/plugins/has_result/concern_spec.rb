# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Concern do
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
    include ConvenientService::RSpec::Helpers::IgnoringException

    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Matchers::Results

    describe "#result" do
      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(service) do |service|
            include ConvenientService::Service::Configs::Essential

            step service
          end
        end
      end

      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Essential

          def result
            success(data: {foo: :bar})
          end
        end
      end

      describe "#result" do
        context "when `organizer` is NOT set" do
          let(:step) { container.steps.first }

          let(:message) do
            <<~TEXT
              Step `#{step.printable_service}` has not assigned organizer.

              Did you forget to set it?
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer`" do
            expect { step.result }
              .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer)
              .with_message(message)
          end

          specify do
            expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer) { step.result } }
              .to delegate_to(ConvenientService, :raise)
          end
        end

        context "when `organizer` is set" do
          let(:step) { container.new.steps.first }

          specify do
            expect { step.result }.to delegate_to(step, :service_result)
          end

          it "returns service result" do
            expect(step.result).to be_success.with_data(foo: :bar)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
