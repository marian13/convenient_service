# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod

        def foo
        end
      end
    end
  end

  let(:service_instance) { service_class.new }

  let(:args) { [Class.new] }
  let(:kwargs) { {in: :foo, out: :bar, container: service_class, index: 0} }
  let(:step) { service_class.step_class.new(*args, **kwargs) }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule
    include ConvenientService::RSpec::Matchers::CacheItsValue

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      it { is_expected.to include_module(described_class::InstanceMethods) }
      it { is_expected.to extend_module(described_class::ClassMethods) }
    end

    example_group "instance methods" do
      describe "#steps" do
        before do
          service_class.step Class.new, in: :foo, out: :bar
        end

        specify { expect { service_instance.steps }.to delegate_to(service_class.steps, :commit!) }

        it "returns `self.class.steps` with `organizer` set to each of them" do
          expect(service_instance.steps).to eq(service_class.steps.map { |step| step.copy(overrides: {kwargs: {organizer: service_instance}}) })
        end

        specify { expect { service_instance.steps }.to cache_its_value }
      end
    end

    example_group "class_methods" do
      describe ".step" do
        it "returns `step`" do
          expect(service_class.step(*args, **kwargs)).to eq(step)
        end

        it "adds `step` to `steps`" do
          expect { service_class.step(*args, **kwargs) }.to change { service_class.steps.include?(step) }.from(false).to(true)
        end
      end

      describe ".raw" do
        let(:value) { :foo }

        specify {
          expect { service_class.raw(value) }
            .to delegate_to(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Values::Raw, :wrap)
            .with_arguments(value)
            .and_return_its_value
        }
      end

      describe ".steps" do
        specify {
          expect { service_class.steps }
            .to delegate_to(ConvenientService::Service::Plugins::HasResultSteps::Entities::StepCollection, :new)
            .and_return_its_value
        }

        specify { expect { service_class.steps }.to cache_its_value }
      end

      describe ".step_class" do
        specify {
          expect { service_class.step_class }
            .to delegate_to(ConvenientService::Service::Plugins::HasResultSteps::Commands::CreateStepClass, :call)
            .with_arguments(service_class: service_class)
            .and_return_its_value
        }

        specify { expect { service_class.step_class }.to cache_its_value }
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
