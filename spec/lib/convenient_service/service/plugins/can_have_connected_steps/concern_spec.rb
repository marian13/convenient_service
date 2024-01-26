# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Concern do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Standard
    end
  end

  let(:service_instance) { service_class.new }

  let(:args) { [Class.new] }
  let(:kwargs) { {in: :foo, out: :bar, container: service_class} }
  let(:step) { service_class.step_class.new(*args, **kwargs.merge(index: 0)) }
  let(:negated_step) { service_class.step_class.new(*args, **kwargs.merge(index: 0, negated: true)) }

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

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".not_step" do
      it "returns negated `step`" do
        expect(service_class.not_step(*args, **kwargs)).to eq(negated_step)
      end

      it "adds negated `step` to `steps`" do
        expect { service_class.not_step(*args, **kwargs) }.to change { service_class.steps.include?(negated_step) }.from(false).to(true)
      end
    end

    describe ".and_step" do
      it "returns `step`" do
        expect(service_class.and_step(*args, **kwargs)).to eq(step)
      end

      it "adds `step` to `steps`" do
        expect { service_class.and_step(*args, **kwargs) }.to change { service_class.steps.include?(step) }.from(false).to(true)
      end
    end

    describe ".and_not_step" do
      it "returns negated `step`" do
        expect(service_class.and_not_step(*args, **kwargs)).to eq(negated_step)
      end

      it "adds negated `step` to `steps`" do
        expect { service_class.and_not_step(*args, **kwargs) }.to change { service_class.steps.include?(negated_step) }.from(false).to(true)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
