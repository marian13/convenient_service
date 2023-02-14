# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Concern do
  include ConvenientService::RSpec::Matchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include ConvenientService::Common::Plugins::HasInternals::Concern

        class self::Internals
          include ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
        end

        include mod

        def foo
        end
      end
    end
  end
  # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

  let(:service_instance) { service_class.new }

  let(:args) { [Class.new] }
  let(:kwargs) { {in: :foo, out: :bar, container: service_class, index: 0} }
  let(:step) { service_class.step_class.new(*args, **kwargs) }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      it { is_expected.to include_module(described_class::InstanceMethods) }
      it { is_expected.to extend_module(described_class::ClassMethods) }
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
    end

    describe "#step" do
      let(:index) { 0 }

      context "when steps have NO step by index" do
        it "returns `nil`" do
          expect(service_instance.step(index)).to be_nil
        end

        specify do
          expect { service_instance.step(index) }
            .to delegate_to(service_instance.steps, :[])
            .with_arguments(index)
            .and_return_its_value
        end
      end

      context "when steps have step by index" do
        before do
          service_class.step Class.new, in: :foo, out: :bar
        end

        it "returns step by index" do
          expect(service_instance.step(index)).to eq(service_instance.steps[index])
        end

        specify do
          expect { service_instance.step(index) }
            .to delegate_to(service_instance.steps, :[])
            .with_arguments(index)
            .and_return_its_value
        end
      end
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

    describe ".raw" do
      let(:value) { :foo }

      specify do
        expect { service_class.raw(value) }
          .to delegate_to(ConvenientService::Support::RawValue, :wrap)
          .with_arguments(value)
          .and_return_its_value
      end
    end

    describe ".reassign" do
      let(:method_name) { :foo }

      specify do
        expect { service_class.reassign(method_name) }
          .to delegate_to(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Values::Reassignment, :new)
          .with_arguments(method_name)
          .and_return_its_value
      end
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
      specify do
        expect { service_class.step_class }
          .to delegate_to(ConvenientService::Service::Plugins::HasResultSteps::Commands::CreateStepClass, :call)
          .with_arguments(service_class: service_class)
          .and_return_its_value
      end

      specify { expect { service_class.step_class }.to cache_its_value }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
