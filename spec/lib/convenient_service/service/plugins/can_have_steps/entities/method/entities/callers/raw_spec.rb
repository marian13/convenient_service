# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Raw, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { described_class.new(raw_value) }
  let(:raw_value) { ConvenientService::Support::RawValue.wrap(:foo) }
  let(:direction) { :input }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base) }
  end

  example_group "instance methods" do
    let(:service_class) { Class.new }
    let(:service_instance) { service_class.new }

    let(:container) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.cast(service_class) }
    let(:organizer) { service_instance }

    let(:method) do
      ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method
        .cast({foo: raw_value}, direction: direction)
        .copy(overrides: {kwargs: {organizer: organizer}})
    end

    describe "#calculate_value" do
      it "delegates to `raw_value.unwrap`" do
        allow(raw_value).to receive(:unwrap).and_call_original

        caller.calculate_value(method)

        expect(raw_value).to have_received(:unwrap)
      end

      it "returns value of `raw_value.unwrap`" do
        expect(caller.calculate_value(method)).to eq(raw_value.unwrap)
      end
    end

    describe "#define_output_in_container!" do
      let(:direction) { :output }
      let(:index) { 0 }

      it "returns `false`" do
        expect(caller.define_output_in_container!(container, index: index, method: method)).to eq(false)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
