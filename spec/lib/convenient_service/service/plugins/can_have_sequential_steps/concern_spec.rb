# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSequentialSteps::Concern do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Minimal
    end
  end

  let(:service_instance) { service_class.new }

  let(:args) { [Class.new] }
  let(:kwargs) { {in: :foo, out: :bar, container: service_class} }
  let(:step) { service_class.step_class.new(*args, **kwargs.merge(index: 0)) }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".step" do
      it "returns `step`" do
        expect(service_class.step(*args, **kwargs)).to eq(step)
      end

      it "adds `step` to `steps`" do
        expect { service_class.step(*args, **kwargs) }.to change { service_class.steps.include?(step) }.from(false).to(true)
      end
    end

    describe ".steps" do
      specify do
        expect { service_class.steps }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSequentialSteps::Entities::StepCollection, :new)
          .with_arguments(container: service_class)
          .and_return_its_value
      end

      specify { expect { service_class.steps }.to cache_its_value }
    end
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

      specify { expect(service_instance.steps).to be_frozen }
    end

    describe "#step" do
      let(:index) { 0 }

      specify do
        ##
        # NOTE: `service_instance.steps` returns frozen object, that is why it is stubbed.
        #
        allow(service_instance).to receive(:steps).and_return([])

        expect { service_instance.step(index) }
          .to delegate_to(service_instance.steps, :[])
          .with_arguments(index)
          .and_return_its_value
      end

      context "when steps have NO step by index" do
        it "returns `nil`" do
          expect(service_instance.step(index)).to be_nil
        end
      end

      context "when steps have step by index" do
        before do
          service_class.step Class.new, in: :foo, out: :bar
        end

        it "returns step by index" do
          expect(service_instance.step(index)).to eq(service_instance.steps[index])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
